//
//  FamilyViewViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import Foundation
import CoreData
import SwiftUI

class FamilyViewViewModel: ObservableObject {
    
    @Published var family = Family()
    @Published var familyMembers = [Member]()
    @Published var leader = Member()
    
    func getFamily(){
        print("____Fetching family________")
        familyMembers = CoreDataManager.shared.getFamilyMembers()
        family = CoreDataManager.shared.getFamily()
       
        
        for member in familyMembers {
            print("_____")
            print(member.name ?? "No name")
            print(member.points)
        }
        setLeader()
    }
    
    func setLeader() {
        print("_____SETTING LEADER")
        leader = familyMembers.first!
        print(leader.name)
    }
    
}
