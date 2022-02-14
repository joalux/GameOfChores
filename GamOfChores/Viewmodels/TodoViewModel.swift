//
//  TodoViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class TodoViewModel: NSObject, ObservableObject {
    
    @StateObject var coreManager = CoreDataManager()
    
    @Published var chores = [Chore]()
    @Published var dayTodo = ""
    
     func fetchChores(){
        chores = CoreDataManager.shared.fetchChores()
         print("Has chores= \(chores.count)")
         for chore in chores {
             print(chore.type)
             print("Completed")
             print(chore.isCompleted)
             print("Day to do")
             print(chore.dayTodo)
         }
    }
   
    func removeChore(chore: Chore){
        do{
            try chore.delete()
        } catch {
            print("ERROR DELETEING")
            print(error.localizedDescription)
        }
        fetchChores()
    }
    
    func setCurrentDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en")
        var currentDay = dateFormatter.string(from: Date())
        
        print("_________")
        print(currentDay)
        dayTodo = currentDay
        
    }
    
}
