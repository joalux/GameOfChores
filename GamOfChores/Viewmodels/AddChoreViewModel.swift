//
//  AddChoreViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData
import SwiftUI

class AddChoreViewModel: ObservableObject {
    
    @State var id = UUID()
    @Published var type = ""
    @Published var customType = ""
    @State var isCompleted = false
    @State var customChore = false
    
    @Published var dayToDo = ""
    
    @Published var selectedType = 0
    @Published var selectedPoints = 0.0
    @Published var timeLimit = 0.0
    
    @State var hasTimeLimit = false
    
    let types = ["Dishes", "Laundry", "Cleaning", "Dinner", "Lunch", "Breakfast", "Windows", "Toilets"]
    
    let points = ["10p", "20p", "30p", "40p", "50p"]
    
    let date = Date()
    @State var currentDayString = ""
    
    init(){
       // setDay()
    }
    
    func choreTimeLimitString(timeLimit: Double) -> String {
        "\(timeLimit) m"
    }
    
    func setDay(activeDay: String?){
        
        if let activeDay = activeDay {
            print("Day to do= \(activeDay)")
            dayToDo = activeDay
            
        }
        else {
            print("no day, setting current!")
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.locale = Locale(identifier: "en")

            dayToDo = dateFormatter.string(from: date)
        }
   
    }
    
    func addNewChore(isCustom: Bool, hasTimeLimit: Bool){
        
        print("Adding new chore!!")
        if hasTimeLimit {
            print("HAS TIME LIMIT!!")

        }
        else {
            print("HAS NOT TIMELIMIT!!")
        }
        do {
            var newChore = Chore(context: CoreDataManager.shared.container.viewContext)
            
            if isCustom {
                newChore.isCustom = true
                newChore.type = customType
            }
            else {
                newChore.isCustom = false
                newChore.type = types[selectedType]
            }
            newChore.value = Int64(selectedPoints)
            
            newChore.hasTimeLimit = hasTimeLimit
            
            newChore.timeLimit = timeLimit
            print("Chore day = \(dayToDo)")
            newChore.dayTodo = dayToDo
            newChore.doneBy = ""
            
            try newChore.save()
            
        } catch {
            print("________ERROR_________")
            print(error.localizedDescription)
        }
    }
}
