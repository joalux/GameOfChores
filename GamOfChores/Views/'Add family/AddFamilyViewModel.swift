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
        
    @Published var coreFamily = CoreDataManager.shared.getFamily()
    
    init() {
        print("___ADD FAM VM____")
        print("CORE FAM= \(coreFamily.familyID)")
        print("Connected = \(coreFamily.isConnected)")
        print("ID = \(coreFamily.firID ?? "No id")")
     getFamMembers()
    }
    
    func addFamMember(name: String, firID: String){
        print("____Adding new member")
        print("CoreFAM!!")
        print(coreFamily.isConnected)
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
 
    
    func removeMember(at offsets: IndexSet){
        print("_____REMOVING MEMBER!!!!")
       
        for index in offsets {
            let member = famMembers[index]
           
            CoreDataManager.shared.removeFamMember(member: member)
           
            famMembers.remove(atOffsets: offsets)
        }
    }
    
    func getFamMembers() {
        
        /*if coreFamily.isConnected {
            //Accessing StateObject's object without being installed on a View. This will create a new instance each time.
            famMembers = firHelper.firMembers
            firHelper.getFirMembers(firID: coreFamily.firID ?? "No id")
            
        }*/
        famMembers = CoreDataManager.shared.getFamilyMembers()
                
       
    }
}
