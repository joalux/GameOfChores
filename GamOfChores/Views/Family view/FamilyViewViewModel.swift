//
//  FamilyViewViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

class FamilyViewViewModel: ObservableObject {
    
    @Published var family = Family()
    @Published var familyMembers = [Member]()
    @Published var leader = Member()
    
    @Published var noFamily = false
    @Published var hasFamily = false
    
    private var db = Firestore.firestore()
    
    func fetchFamily(){
        print("____Fetching family________")
        family = CoreDataManager.shared.getFamily()
        print("IS CONNECTED=  \(family.isConnected)")
        
        if family.isConnected {
            print("Fetching firfam!!!")
            familyMembers.removeAll()
            print(family.mail!)
            print(family.firID)
            
            var firFam = [Member]()
            
            let docRef = db.collection("Families").document(family.firID!)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
            
            db.collection("Families").document(family.firID!).collection("Family members").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        let data = document.data()
                        
                       let firName = data["Name"] as? String
                        let firPoints = data["Points"] as? Int
                        let firCount = data["ChoreCount"] as? Int
                        let firTime = data["Time"] as? Double
                        
                       // firFam.append( FireBaseHelper.shared.setFirMember(famFirId: self.family.firID!, memberID: document.documentID, firName: firName ?? "No name", firPoints: firPoints ?? 0, firTime: firTime ?? 0, firCount: firCount ?? 0))
                        
                        print("Appended member: \(firFam.count)")
                    }
                    self.familyMembers = firFam
                    self.setLeader()
                }
            }
        }
        else {
            print("NOT CONNECTED!")
            familyMembers = CoreDataManager.shared.getFamilyMembers()
            print(familyMembers.count)
            if familyMembers.count == 0 {
                noFamily = true
                hasFamily = false
            }
            else {
                setFamily()
                hasFamily = true
                self.setLeader()

            }
        }
    }
    
    
    func setFamily(){
        print("___Setting family")
        for member in familyMembers {
            print(member.name)
            print(member.points)
            print(member.choreCount)
        }
    }
    
    func setLeader() {
        print("_____SETTING LEADER")
        if let unwrappedLeader = familyMembers.first {
            leader = unwrappedLeader
            print(leader.name ?? "No name")
        } else {
            print("No leader")
        }
        self.hasFamily = true

       
    }
    
}
