//
//  FirebaseManager.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import Foundation
import Firebase
import SwiftUI

class FireBaseHelper: ObservableObject {
    
    static let shared = FireBaseHelper()
    
    var db = Firestore.firestore()
    
    @Published var firSuccess = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var firError = false

    @Published var firMembers = [Member]()
    var firFamily = Family()
    
    @Published var firChores = [Chore]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var completedFirChores = [Chore]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var firErrorString = ""
    
    // MARK: - Family functions
    func joinFamily(firID: String){
        print("____JOINGIN FAMILY!!!")
        print("_____\(firID)")
    }
    
    func addFamily(firID: String, mail: String) -> Bool {
        print("______ADDING FAM DOC!!!!")
        print("_____\(firID)")
        print(mail)
                
        db.collection("Families").document(firID).setData([
            "Signup date": Date(),
            "Mail": mail
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                self.firError = true
                self.firSuccess = false
            } else {
                print("Document successfully written!")
                self.firSuccess = true
            }
        }
        return firSuccess
    }
  
    func resetFamily(firID: String) {
        print("RESETTING!!!!")
        db.collection("Families").document(firID).collection("Family members").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.resetMember(firID: firID, memberID: document.documentID)
                    
                }
            }
        }
    }
    
    func removeFamily(firID: String) {
        removeAll(firID: firID, resetToDo: true)
        removeAll(firID: firID, resetToDo: false)
    
        db.collection("Families").document(firID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                self.firErrorString = "\(err.localizedDescription)"
                self.firError = true
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func addFirMembers(firID: String, famMembers: [Member]) {
        print("Adding new Firmembers: ", famMembers.count)
        
        for member in famMembers {
            print("ADDING MEMBER:", member.memberID)
            if let id = member.memberID?.uuidString {
                db.collection("Families").document(firID).collection("Family members").document(id).setData([
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
                        self.firMembers.append(member)
                        print("FIRCOUNT: ", self.firMembers.count)
                        print("FAMCOUNT: ", famMembers.count)

                        if self.firMembers.count == famMembers.count {
                            print("FAMILY COMPLETE!!")
                            self.firSuccess = true
                        }
                    }
                }
            }
        }
    }
        
    func addNewFirMember(firID: String, memberID: String, firName: String) {
        print("Adding new Firmember")
        firSuccess = false
        if firName != "" {
            print("HAS NAME \(firName)!!")
            

            db.collection("Families").document(firID).collection("Family members").document(memberID).setData([
                "Name": firName,
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
                    print("Document added with member ID: \(memberID)")
                    
                }
            }
            print("FIRMEMBERS ADDED!! ", self.firMembers.count)
        }
    }
    
    func updateMember(firID: String, firMember: Member){
        print("UPDATING MEMBER!!!")
        print(firID)
        if let memberID = firMember.memberID {
            print("MEMBER ID = \(memberID)")
            print(firMember.firID)
            let memberRef = db.collection("Families").document(firID).collection("Family members").document(memberID.uuidString)
            memberRef.updateData([
                "Points": firMember.points,
                "Time": Int64(firMember.time),
                "ChoreCount": firMember.choreCount
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    self.firErrorString = "\(err.localizedDescription)"

                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func setFirMember(famFirId: String, memberID: String, firName: String = "", firPoints: Int = 0, firTime: Double = 0, firCount: Int = 0){
        
        var firMember = CoreDataManager.shared.setMember(id: UUID(uuidString: memberID) ?? UUID(), firID: famFirId, name: firName, points: firPoints, time: firTime, choreCount: Int64(firCount))
        
    }
    
    func resetMember(firID: String, memberID: String) {
        print("resetting firmember!!")
        let memberRef = db.collection("Families").document(firID).collection("Family members").document(memberID)
        memberRef.updateData([
            "ChoreCount" : 0,
            "Points" : 0,
            "Time" : 0
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Member successfully reset")
            }
        }
    }
    
    func removeMemAtOffsets(at offsets: IndexSet) {
        
        for index in offsets {
            let firMember = firMembers[index]
            print("Removing firmemember: \(firMember.name), firID = \(firMember.firID), memberID = \(firMember.memberID)")
            if let firID = CoreDataManager.shared.getFamily().firID {
                removeMember(firID: firID, memberID: firMember.firID ?? "")
            }
        }
        firMembers.remove(atOffsets: offsets)
    }
    
    func removeMember(firID: String, memberID: String){
        print("Removing fir member!!! ID = \(memberID)")
        db.collection("Families").document(firID).collection("Family members").document(memberID).delete() { err in
                   if let err = err {
                       print("Error removing document: \(err)")
                   } else {
                       print("Document successfully removed!")
                   }
               }
    }
    
    func getFirMembers(firID: String){
        print("__Fetching firmembers!!")
        db.collection("Families").document(firID).collection("Family members").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var newMember = Member(context: CoreDataManager.shared.container.viewContext)
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    newMember.firID = document.documentID
                    newMember.choreCount = data["ChoreCount"] as? Int64 ?? 0
                    newMember.name = data["Name"] as? String
                    newMember.points = data["Point"] as? Int64 ?? 0
                    newMember.time = data["Time"] as? Double ?? 0
                    
                    self.firMembers.append(newMember)
                    
                }
                print("HAS FIRMEMBERS!!!")
                print("FirCount = \(self.firMembers.count)")
            }
        }
    }
    
    // MARK: - Chore functions
    
    func getFirChores(getCompleted: Bool, refresh: Bool) {
        print("Fetching firchores!!!")
        print("FirID == \(CoreDataManager.shared.getFamily().firID)")
        var newFirChores = [Chore]()
        
        var choreRef = "To do"
        
        if getCompleted {
            choreRef = "Completed chores"
        }
        
        if let firID = CoreDataManager.shared.getFamily().firID {
            do {
                db.collection("Families").document(firID).collection(choreRef).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                           // print("\(document.documentID) => \(document.data())")
                            var newFirChore = Chore(context: CoreDataManager.shared.container.viewContext)

                            newFirChore.choreID = UUID(uuidString: document.documentID)

                            let data = document.data()
                            
                            var timeLimit = data["Timelimit"] as? Double
                                                        
                            newFirChore.type = data["Type"] as? String ?? ""
                            newFirChore.value = Int64(data["Points"] as? Int ?? 0)
                            newFirChore.dayTodo = data["Day todo"] as? String ?? ""
                            newFirChore.hasTimeLimit = data["Has timelimit"] as? Bool ?? false
                            newFirChore.timeLimit = data["Timelimit"] as? Double ?? 0
                            newFirChore.isCustom = data["isCustom"] as? Bool ?? false
                            newFirChore.doneBy = data["Done by"] as? String ?? ""
                            
                            
                            
                            if getCompleted {
                                let dateCompleted = data["Time completed"] as? Date ?? Date()
                            }
                                                        
                            
                            if getCompleted {
                                newFirChore.isCompleted = true
                                self.completedFirChores.append(newFirChore)
                                print("Addindg to completed!!")
                                
                            } else {
                                newFirChore.isCompleted = false
                                newFirChore.doneBy = ""
                            }
                            
                            newFirChores.append(newFirChore)
                        }
                      
                        print("NEW FIRCHORECOUNT == \(newFirChores.count)")
                       
                    }
                }
            }
        }
    }
    
    func addChore(firID: String, firChore: Chore) {
        print("Adding firchore")
        print(firChore.choreID)
        print(firChore.type)
        db.collection("Families").document(firID).collection("To do").document(firChore.choreID?.uuidString ?? UUID().uuidString).setData([
            "Type": firChore.type,
            "Points": firChore.value,
            "Has timelimit": firChore.hasTimeLimit,
            "Timelimit": firChore.timeLimit,
            "isCustom": firChore.isCustom,
            "Day todo": firChore.dayTodo,
            "Date todo": firChore.dateToDo
        ])
    }
   
    
    func completeChore(firID: String, firChore: Chore){
        print("Completing firchore")
        print(firChore.choreID)
        db.collection("Families").document(firID).collection("Completed chores").document("\(firChore.choreID ?? UUID())").setData([
            "Type": firChore.type,
            "Points": firChore.value,
            "Time completed": firChore.timeCompleted,
            "Time spent": firChore.timeSpent,
            "isCustom": firChore.isCustom,
            "Done by": firChore.doneBy
        ])
        removeChore(firID: firID, choreID: firChore.choreID?.uuidString ?? "")
    }
    
    func removeChore(firID: String, choreID: String) {
        print("REMOVING FIRCHORE!!")
        print(firID)
        print(choreID)
        db.collection("Families").document(firID).collection("To do").document(choreID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func removeAll(firID: String, resetToDo: Bool) {
        var allChoreIDs = [String]()
        
        var collectionPath = ""
        
        if resetToDo {
            collectionPath = "To do"
        }
        else {
            collectionPath = "Completed chores"
        }

    
        print("Resetting \(collectionPath)")
        db.collection("Families").document(firID).collection(collectionPath).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    allChoreIDs.append(document.documentID)
                    
                }
            }
            for id in allChoreIDs {
                print("REMOVING CHORE WITH ID = \(id)")
                self.db.collection("Families").document(firID).collection(collectionPath).document(id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
        
        
    }
    
}
