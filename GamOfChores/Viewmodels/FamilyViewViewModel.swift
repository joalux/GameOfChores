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
    
    func getFamily(){
        familyMembers = CoreDataManager.shared.getFamilyMembers()
        family = CoreDataManager.shared.getFamily()
        
        for member in familyMembers {
            print(member.name)
            print(member.points)
        }
    }
    
}
