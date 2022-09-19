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
    
    @Published var activeFamily: Family
    
    @State var id = UUID()
    @Published var type = "Dishes"
    @Published var customType = ""
    @State var isCompleted = false
    @State var customChore = false
    
    @State var noType = false

    @Published var dateToDo = Date()
    @Published var dayToDo = ""
    @Published var selectedDay = "Monday"
    
    @Published var selectedType = 0
    @Published var selectedPoints = 0.0
    @Published var timeLimit = 0.0
    
    @State var hasTimeLimit = false
    
    let types = ["Dishes", "Laundry", "Cleaning", "Dinner", "Lunch", "Breakfast", "Windows", "Toilets"]
    
    let points = ["10p", "20p", "30p", "40p", "50p"]
    
    let date = Date()
    @State var currentDayString = ""
    
    init(){
        activeFamily = CoreDataManager.shared.getFamily()
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
    
    func setDate(newDate: Date) {
        dateToDo = newDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_us")
        dayToDo = dateFormatter.string(from: dateToDo)
    }
    
    func addNewChore(isCustom: Bool, templateMode: Bool) {
        
        print("___Adding new chore!!")
        print("___type = \(type)")
        print("_____DAY = \(dayToDo)")
        print("_____DATE = \(dateToDo)")
        print("____TEMPLATEMODE = \(templateMode)")
        if templateMode {
            dayToDo = selectedDay
        }
        
        var newChore = Chore(context: CoreDataManager.shared.container.viewContext)
        
        if isCustom {
            type = customType
        }
        newChore.choreID = UUID()
        newChore.type = type
        newChore.dayTodo = dayToDo
        newChore.doneBy = ""
        newChore.dateToDo = dateToDo
        newChore.value = Int64(selectedPoints)
        newChore.isCustom = isCustom
        newChore.timeLimit = timeLimit
        newChore.isTemplate = templateMode
        
        if timeLimit > 0 {
            newChore.hasTimeLimit = true
        }
        else {
            newChore.hasTimeLimit = false
        }
        
        CoreDataManager.shared.save()
    
        if activeFamily.isConnected {
            FireBaseHelper.shared.addChore(firID: activeFamily.firID ?? "", firChore: newChore)
        }
     
    }
}
