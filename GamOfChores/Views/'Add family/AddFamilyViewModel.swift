//
//  AddFamilyViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class AddFamilyViewModel: ObservableObject {
        
    @Published var memberName = ""
    @Published var memberNames = [String]()
    @Published var famMembers = [Member]()
    
    @Published var showConnectAlert = false
    @Published var showNoNameAlert = false
    
    @Published var firLoading = false
    @Published var firSuccess = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var firHelper = FireBaseHelper()
    @Published var firErrorString = ""
    
    @Published var firError = false
        
    @Published var coreFamily = CoreDataManager.shared.getFamily()
        
    init() {
        print("___ADD FAM VM____")
        print("CORE FAM= \(coreFamily.familyID)")
        print("Connected = \(coreFamily.isConnected)")
        print("ID = \(coreFamily.firID ?? "No id")")
        //getFamMembers()
    }
    
  
    
    func addFamily(){
        print("ADDING FAM:", memberNames.count)
       
        for name in memberNames {
            print("Adding new member: ", name)
            let newID = UUID()
            var newMember = Member(context: CoreDataManager.shared.container.viewContext)
            newMember.memberID = newID
            newMember.name = name
            newMember.points = 0
            newMember.choreCount = 0
            newMember.time = 0
            
            print("___NEW MEM ID!!")
            print(newMember.memberID)
            
            CoreDataManager.shared.save()
            famMembers.append(newMember)
            
        }

        if coreFamily.isConnected {
            var firCount = 0
            
            for member in famMembers {
                if let id = member.memberID?.uuidString {
                    firHelper.db.collection("Families").document(coreFamily.firID!).collection("Family members").document(id).setData([
                        "Name": member.name!,
                        "Points": 0,
                        "Time": 0,
                        "ChoreCount": 0
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            self.firErrorString = "\(err.localizedDescription)"

                            self.firError = true
                            self.firSuccess = false
                        } else {
                            print("Document successfully written!")
                            print("Document added with member ID: \(id)")
                            firCount += 1
                            
                            if firCount == self.famMembers.count {
                                print("FAM COMPLETE!!")
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    
    func removeMember(at offsets: IndexSet){
        print("_____REMOVING MEMBER!!!!")
       
        for index in offsets {
            let member = famMembers[index]
           
            CoreDataManager.shared.removeFamMember(member: member)
           
            famMembers.remove(atOffsets: offsets)
        }
    }
    
    func getFamMembers() {
        
        let coreMembers = CoreDataManager.shared.getFamilyMembers()
        for member in coreMembers {
            print(member.name)
            if member.name != nil {
                famMembers.append(member)
            }
        }
        print("GOT FAM: ", famMembers.count)
    }
    
    func resetFamily() {
        print("RESETTING FAM")
        for member in famMembers {
            CoreDataManager.shared.removeFamMember(member: member)
        }
        famMembers.removeAll()
    }
}
