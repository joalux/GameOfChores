//
//  AddFamilyViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import Foundation
import CoreData
import SwiftUI

class AddNewFamilyViewModel: ObservableObject {
        
    @State var memberName = ""
    @Published var memberNames = [String]()
    
    init() {
        print("Initing family model")
    }
    
    func addFamMembers(){
        for name in memberNames {
            do {
            var newMember = Member(context: CoreDataManager.shared.container.viewContext)
                newMember.id = UUID()
            newMember.name = name
            newMember.points = 0
            newMember.time = 0
            print("Added new member name= \(newMember.name)")
            try newMember.save()
            } catch {
                print("________ERROR_________")
                print(error.localizedDescription)
            }
        }
    }
    
    func addFamily(famMail: String){
        var newFamily = Family(context: CoreDataManager.shared.container.viewContext)

        newFamily.id = UUID()
                
        CoreDataManager.shared.save()
    }

}
