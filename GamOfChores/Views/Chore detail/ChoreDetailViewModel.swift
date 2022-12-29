//
//  ChoreDetailViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-15.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

@MainActor
class ChoreDetailViewModel: ObservableObject {

    @Published var selectedChore = Chore()
    
    @Published var familyMembers = [Member]()
    
    @Published var family = Family()
    
    let db = Firestore.firestore()
    
    @Published var isConnected = false
    
    var timer = Timer()
    
    enum timerhMode {
        case running
        case stopped
        case paused
    }
    
    @Published var minutes = 0
    @Published  var seconds = 0
    @Published  var timeSpent = 0

    @Published var buttonText = "Start"
    @State var isCustom = false
    @Published var isCounting = false
    @Published var hasStarted = false
    @State var hasTimeLimit = false
    @Published var hasEnded = false
    @Published var hasCompleted = false
    
    @Published var hasFamily = false
    
    init() {
        print("_____DETAIL VM_____")
       // getFamily()
        fetchFam()
    }
    
    func fetchFam() {
        print("Fetching fam!!")
        family = CoreDataManager.shared.getFamily()
        
        if family.isConnected {
            print("IS Connected!!")
            isConnected = true
            
        
        
            db.collection("Families").document(family.firID!).collection("Family members").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("")
                        print("____________FIRMEMBER DATA_________________")
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let memberID = document.documentID
                        let firName = data["Name"] as? String
                        let firPoints = data["Points"] as? Int
                        let firCount = data["ChoreCount"] as? Int
                        let firTime = data["Time"] as? Double
                        print("_________________________________")
                        
                        if let firName = firName {
                            print("______FIRNAME = \(firName)")
                           // self.familyMembers.append( FireBaseHelper.shared.setFirMember(famFirId: self.family.firID!, memberID: memberID, firName: firName, firPoints: firPoints ?? 0, firTime: firTime ?? 0, firCount: firCount ?? 0 ))
                        }
                        
                    }
                }
            }
        }
        else {
            familyMembers = CoreDataManager.shared.getFamilyMembers()
        }
        
       
    }
    
    func setTimer(reset: Bool){
        
        if reset {
            restartTimer()
        }
        else {
            if isCounting {
                pauseTimer()
            }
            else {
                startTimer(resume: hasStarted)
            }
        }
     
    }
    
    func startTimer(resume: Bool){
        isCounting = true
        hasStarted = true
        buttonText = "Pause"
        print("START Time limit ========= \(selectedChore.timeLimit)")
        if resume == false{
            minutes = Int(selectedChore.timeLimit)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: isCounting){ tempTimer in
            
            print(self.seconds)
            
            if self.selectedChore.hasTimeLimit {
                self.seconds -= 1
                if self.seconds <= 0 {
                    print("ONE MINUTE!!!!")
                    self.timeSpent += 1
                    self.minutes -= 1
                    self.seconds = 59
                    if self.minutes <= 0 {
                        self.hasEnded = true
                    }
                }
            }
            else {
                self.seconds += 1
                if self.seconds >= 60 {
                    print("ONE MINUTE!!!!")
                    self.timeSpent += 1
                    self.minutes += 1
                    self.seconds = 0

                }

            }
        }
    }
    
    func pauseTimer(){
        print("____Pausing timer!!!")
        buttonText = "Start"
        timer.invalidate()
        isCounting = false
    }
    
    func restartTimer(){
        print("____Restarting timer!!!")

        buttonText = "Start"
        timer.invalidate()
        isCounting = false
        hasStarted = false
        
        timeSpent = 0
        
        if selectedChore.hasTimeLimit {
            minutes = Int(selectedChore.timeLimit)
        }
        else {
            minutes = 0
        }
        seconds = 0
    }
    
    func completeChore(selectedMembers: Set<Member>){
        print("____COMPLETEING CHORE!!!DONE BY: \(selectedMembers) ")
        var saveError = false
        timer.invalidate()
        selectedChore.isCompleted = true
        selectedChore.timeSpent = Double(timeSpent)
        selectedChore.timeCompleted = Date()
        
        print("___Selected members:")
        for member in selectedMembers {
            print("MEMBER: \(member.name), \(member.isSelected)")
            print("Adding points to: \(member.name) \(member.memberID), \(member.firID)")
            member.points += selectedChore.value
            member.time += Double(timeSpent)
            //member.completedChores?.append(selectedChore)
            member.choreCount += 1
            
            selectedChore.doneBy! += "\(member.name!),"
            
            do {
                try member.save()
            } catch  {
                print("Error saving!!!!")
                saveError = true
            }
            if family.isConnected {
                print("UPDATING FIRMEMEBER!!!!!!")
                print(member.memberID)
                print(member.name)
                print(member.points)
                //print(member.completedChores?.count)
                
                
                FireBaseHelper.shared.updateMember(firID: family.firID ?? "", firMember: member)
            }
        }
        
        do {
            try CoreDataManager.shared.save()
        } catch  {
            print("Error saving!!!!")
            saveError = true
            
        }
        if saveError == false && family.isConnected {
            FireBaseHelper.shared.completeChore(firID: family.firID ?? "", firChore: selectedChore)

        }
        hasCompleted = true

    }
}
