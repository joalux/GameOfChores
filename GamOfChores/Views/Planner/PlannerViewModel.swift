//
//  PlannerViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-23.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

@MainActor
class PlannerViewModel: ObservableObject {
    
    let weekDaysShort = ["Mon", "Tu", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let weekDaysFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
            
    private var db = Firestore.firestore()
    
    @StateObject var coreManager = CoreDataManager()
    
    @ObservedObject var todoVM = TodoViewModel()
    
    let formatter = DateFormatter()
    
    @Published var chores = [Chore]()
    
    @Published var family = Family()
    
    @Published var currentDayIndex = 0
    @Published var oldDayIndex = 0
    @Published var todayIndex = 0
    @Published var dayIndex = 0
    
    @Published var listHeight = 0.0

    @Published var currentDate = Date()
    @Published var selectedDate = Date()
    @Published var selectedDay = ""
    
    @Published var dayIndeces = 0...6
    
    @Published var isConnected = false
    @Published var buttonEnabled = true
    @Published var showLoadAlert = false
    
    let dateFormatter = DateFormatter()
    
    init() {
        
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale.current
        selectedDay = dateFormatter.string(from: Date()).capitalizingFirstLetter()
              
        setConnection()

        getCurrentDayIndex()
        getWeekIndex(date: Date())
    }
    
    func setConnection() {
        family = CoreDataManager.shared.getFamily()
        if family.isConnected {
            isConnected = true
        }
         else {
            isConnected = false
        }
    }
    
    func fetchChores() {
        if isConnected {
            getFirChores()
        }
        else {
            getCoreChores()
        }
    }
    
    func getCoreChores() {
       print("_____Fetching core chores!!!!")
        print("____CURRENT LOCALE === \(Locale.current)")

        var coreChores = CoreDataManager.shared.getChores()
        for chore in coreChores {
            if chore.isTemplate == false {
                if chores.contains(chore) == false {
                    print("___Appending chore \(chore.dateToDo)1!!1")
                    chores.append(chore)

                }
              
            }
        }
        print("___SETTING LISTHEIGHT")
        listHeight = Double(chores.count * 60)
        print("___LIST HEIGHT: ", listHeight)
    }
    
    func getFirChores() {
        
        if let firID = family.firID {
            
                db.collection("Families").document(firID).collection("To do").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            var newFirChore = Chore(context: CoreDataManager.shared.container.viewContext)

                            newFirChore.choreID = UUID(uuidString: document.documentID)

                            let data = document.data()
                            newFirChore.type = data["Type"] as? String ?? ""
                            newFirChore.value = Int64(data["Points"] as? Int ?? 0)
                            
                            let timeStamp = data["Date todo"] as? Timestamp
                            
                            newFirChore.dayTodo = data["Day todo"] as? String ?? ""
                            newFirChore.hasTimeLimit = data["Has timelimit"] as? Bool ?? false
                            newFirChore.timeLimit = data["timelimit"] as? Double ?? 0
                            newFirChore.isCustom = data["isCustom"] as? Bool ?? false
                            newFirChore.doneBy = data["Done by"] as? String ?? ""

                            newFirChore.dateToDo = timeStamp?.dateValue()
                            
                            print("____NEW CHORE DATE === \(newFirChore.dateToDo)")
                                                        if self.chores.contains(newFirChore) {
                                print("____IS IN CHORES")
                            }
                            else {
                                self.chores.append(newFirChore)
                            }
                        }
                        print("___HAS FIRCHORES = \(self.chores.count)")
                        
                        print("___SETTING LISTHEIGHT")
                        self.listHeight = Double(self.chores.count * 60)
                        print("___LIST HEIGHT: ", self.listHeight)

                    }
                }
            
        }
    }
    
    func getTemplateChores() {
        print("___Loading template weekday = \(selectedDate.get(.weekday)), day = \(selectedDate.get(.day)) week = \(selectedDate.get(.weekOfYear))")
        print("____")
        
        var coreChores = CoreDataManager.shared.getChores()
        
        var templateChores = [Chore]()
        
        for coreChore in coreChores {
            
            if coreChore.isTemplate == true  {
               print("___IS TEMPLATE!!!")
                print("___DAY TO DO === \(coreChore.dayTodo!)")
                templateChores.append(coreChore)
          
            }
        }
        print("____")
        print("___TemplateChores == \(templateChores.count)")
        print("")
        setChoreDates(chores: templateChores)
    }
    
    func selectDay(newDate: Date) {
        let weekDay = dateFormatter.string(from: newDate)
        selectedDay = weekDay.capitalizingFirstLetter()

    }
    
    func setDay(){
        
        print("___Date = \(Date().get(.day))")
        print("___Current = \(currentDate.get(.day))")
        print("___Selected = \(selectedDate.get(.day))")
        if selectedDate.get(.day) < Date().get(.day) {
            buttonEnabled = false
        }
    
        if currentDayIndex > oldDayIndex {
            print("___Next day")
            currentDayIndex = 0
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)
            if let newDate = newDate {
                selectedDate = newDate
                
            }
            let weekDay = dateFormatter.string(from: selectedDate)
            selectedDay = weekDay.capitalizingFirstLetter()
            
            if selectedDate.get(.day) < Date().get(.day) {
                buttonEnabled = false
            }
            else {
                buttonEnabled = true
            }
            print("____NEXT DATE___\(selectedDate.get(.day))")
            print("___DATE___\(Date().get(.day))")
            
            
        }
        else if currentDayIndex < oldDayIndex {
            print("___Previous day")
            currentDayIndex = 0
            let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)
            if let newDate = newDate {
                selectedDate = newDate
            }
            let weekDay = dateFormatter.string(from: selectedDate)
            selectedDay = weekDay.capitalizingFirstLetter()
            
            if selectedDate.get(.day) < Date().get(.day) {
                buttonEnabled = false
            }
            
            print("__________PREVIOUS DATE________\(selectedDate.get(.day))_______")
            
        }
        
    }
    
    func setChoreDates(chores: [Chore]) {
        print("_____Setting chore dates \(selectedDate)!!")
        print("____CURRENT LOCALE === \(Locale.current)")
        let weekDay = dateFormatter.string(from: selectedDate)
        getCurrentDayIndex()
        print("____currentDay = \(currentDayIndex)")
        print("____DayIndex = \(getWeekDayIndex(date: selectedDate))")
        print("___ SELECTED WEEK = \(getWeekIndex(date: selectedDate))")
       
        var tempDate = selectedDate
        
        while getWeekDayIndex(date: tempDate) != 1 {
            if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate) {
                print("___NEW DATE = \(newDate)")
                tempDate = newDate
            }
        }
        print("_____MONDAY =  \(dateFormatter.string(from: tempDate)) \(getWeekDayIndex(date: tempDate))")
        print("")
        
        for chore in chores {
            print("____CHOREDAY = \(chore.dayTodo!)")
            print("____CHOREDATE = \(chore.dateToDo)")
            
            
            if let day = chore.dayTodo {
                if day == "Monday" {
                    print("____MONDAY")
                    chore.dateToDo = tempDate
                }
                else if day == "Tuesday" {
                    print("____TUESDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                else if day == "Wednesday" {
                    print("____WEDNESDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 2, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                else if day == "Thursday" {
                    print("____THURsDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 3, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                else if day == "Friday" {
                    print("____FRIDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 4, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                else if day == "Saturday" {
                    print("____SATURDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 5, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                else if day == "Sunday" {
                    print("____SUNDAY")
                    if let newDate = Calendar.current.date(byAdding: .day, value: 6, to: tempDate) {
                        print("___NEW DATE = \(newDate)")
                        chore.dateToDo = newDate
                    }
                }
                print("____DAY = \(chore.dateToDo) day \(dateFormatter.string(from: chore.dateToDo!))")
                do {
                    try chore.save()
                } catch {
                    print("___ERROR SAVING")
                }
                
                self.chores.append(chore)
            }
        }
    }
    
    func getDay() -> String {
        print(selectedDay)
        return selectedDay
    }
    
    func getDayIndex(selectedDate: Date){
        let dayIndex = Calendar.current.component(.weekday, from: selectedDate) - 1
        currentDayIndex = dayIndex
        oldDayIndex = dayIndex
        print("______CURRENT DAY INDEX = \(currentDayIndex)")
    }
    
    func getCurrentDayIndex(){
        let dayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        currentDayIndex = dayIndex
        oldDayIndex = dayIndex
        print("______CURRENT DAY INDEX = \(currentDayIndex)")
    }
    
    func getWeekDayIndex(date: Date) -> Int {
        let dayIndex = Calendar.current.component(.weekday, from: date) - 1
        print("______CURRENTDAY INDEX = \(dayIndex)")
        return dayIndex
    }
    func getWeekIndex(date: Date) -> Int {
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date) - 1
        print("________WEEK == \(weekOfYear)")
        return weekOfYear
    }
    
    func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}
