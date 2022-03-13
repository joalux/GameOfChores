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
    
    @Published var noFamily = false
    
    init(){
        getFamily()
    }
    func getFamily(){
        print("____Fetching family________")
        familyMembers = CoreDataManager.shared.getFamilyMembers()
        family = CoreDataManager.shared.getFamily()
        
        if familyMembers.count == 0 {
            print("NO FAM")
            noFamily = true
        }
        else {
            print("HAS FAM")
            noFamily = false
        }
        
        for member in familyMembers {
            print("_____")
            print(member.name ?? "No name")
            print(member.points)
        }
        
        
        setLeader()
    }
    
    func setLeader() {
        print("_____SETTING LEADER")
        if let unwrappedLeader = familyMembers.first {
            leader = unwrappedLeader
            print(leader.name ?? "No name")
        } else {
            print("No leader")
        }
       
    }
    
}
