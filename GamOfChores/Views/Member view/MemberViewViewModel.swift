//
//  MemberViewViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-12.
//

import Foundation
import SwiftUI
import CoreData
import Firebase

class MemberViewViewModel: ObservableObject {
    
    @Published var selectedMember: Member?
    
    private var db = Firestore.firestore()

    @Published var completedChores = [Chore]()
    @Published var memberChores = [Chore]()

    @Published var isConnected = false
    
    @ObservedObject var firHelper = FireBaseHelper()
    
    func getCompleted(){
        print("________Fetching user chores!!")
        
        if CoreDataManager.shared.getFamily().isConnected  {
            print("IS CONNECTED!!!")
        
            
            getFirchores()
            firHelper.getFirChores(getCompleted: true, refresh: false)
            
        }
        else {
            completedChores = CoreDataManager.shared.getChores()
            sortCompleted()
        }
        
       
    }
    
    func getFirchores(){
        if let firID = CoreDataManager.shared.getFamily().firID {
            do {
                db.collection("Families").document(firID).collection("Completed chores").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                           // print("\(document.documentID) => \(document.data())")
                            var newFirChore = Chore(context: CoreDataManager.shared.container.viewContext)

                            newFirChore.choreID = UUID(uuidString: document.documentID)

                            let data = document.data()
                                                                                    
                            newFirChore.type = data["Type"] as? String ?? ""
                            newFirChore.value = Int64(data["Points"] as? Int ?? 0)
                            newFirChore.dayTodo = data["Day todo"] as? String ?? ""
                            newFirChore.hasTimeLimit = data["Has timelimit"] as? Bool ?? false
                            newFirChore.timeLimit = data["Timelimit"] as? Double ?? 0
                            newFirChore.isCustom = data["isCustom"] as? Bool ?? false
                            newFirChore.doneBy = data["Done by"] as? String ?? ""
                            
                            var timeStamp = data["Time completed"] as? Timestamp
                            print(timeStamp)
                            
                            newFirChore.timeCompleted = timeStamp?.dateValue()
                            
                            newFirChore.isCompleted = true
                            
                            if newFirChore.doneBy!.contains((self.selectedMember?.name)!){
                                print("Member has done it!")
                                self.completedChores.append(newFirChore)
                                print("Addindg to completed!!")
                            }
                            
                            
                        }
                        print("HAS FIRCHORES!!")
                        self.sortCompleted()
                    }
                }
            }
        }
    }
    
    func sortCompleted() {
        print("Sorting completed!!")
        print("____HAS CHORES: \(completedChores.count)")
        for chore in completedChores {
            
            var doneBy = chore.doneBy!.components(separatedBy: ",")
         
            print("Done by count= \(doneBy.count)")
            print("Done by = \(doneBy)")
            
            print(selectedMember!.name!)
            if doneBy.contains(selectedMember!.name!) {
                print("HAS DONE IT!!!")
                if memberChores.contains(chore) == false {
                    memberChores.append(chore)
                }
            }
            
            /*
            if doneBy.contains(selectedMember!.name!){
                memberChores.append(chore)
                selectedMember?.choreCount = Int64(memberChores.count)
                print("Complete count: \(completedChores.count)")
               
            }*/
        }
    }
    
    func setStats(){
    }
}
