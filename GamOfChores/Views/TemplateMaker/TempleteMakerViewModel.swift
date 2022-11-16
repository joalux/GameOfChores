//
//  TempleteMakerViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-08-29.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

@MainActor
class TempleteMakerViewModel: ObservableObject {
    
    @Published var templateChores = [Chore]()
    
    var weekDaysFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var types = ["Dishes", "Laundry", "Cleaning", "Dinner", "Lunch", "Breakfast", "Windows", "Toilets"]
    
    @Published var selectedDay = "Monday"
    
    @Published var selectedType = "Dishes"
    
    func fetchChores() {
        print("____Fetching chores to template!!")
        let allChores = CoreDataManager.shared.getChores()
        
        for chore in allChores {
            if chore.isTemplate {
                if templateChores.contains(chore) {
                    print("____IN CHORES!!!")
                } else {
                    templateChores.append(chore)
                }
            }
        }
    }
}
