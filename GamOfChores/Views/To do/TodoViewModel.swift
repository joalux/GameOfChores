//
//  TodoViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

@MainActor
class TodoViewModel: NSObject, ObservableObject {
    
    @ObservedObject var firHelper = FireBaseHelper()
    
    @Published var choresTodo = [Chore]()
    @Published var completedChores = [Chore]()
    
    private var db = Firestore.firestore()
    
    @Published var dayTodo = ""
    @Published var choreCount = 0
    
    @Published var hasToDo = false
    @Published var hasCompleted = false
    
    @Published var isConnected = false
    
    @Published var currentDate = Date()
    @Published var currentWeek = [Date]()
    
    func setConnection() async {
        if CoreDataManager.shared.getFamily().isConnected {
            isConnected = true
         
            await getFirChores(getCompleted: false, refresh: false)
            await getFirChores(getCompleted: true, refresh: false)
            
            firHelper.getFirChores(getCompleted: false, refresh: false)
        }
         else {
             isConnected = false
            getCoreChores(getCompleted: false)
             getCoreChores(getCompleted: true)

        }
    }
    
    func getCoreChores(getCompleted: Bool){
   
        var coreChores = CoreDataManager.shared.getChores()
                
        if getCompleted {
            sortChores(newChores: coreChores, sortCompleted: true, refresh: false)
        } else {
            sortChores(newChores: coreChores, sortCompleted: false, refresh: false)
        }
    }
    
    func getFirChores(getCompleted: Bool, refresh: Bool) {
        var newFirChores = [Chore]()
        
        var choreRef = "To do"
        
        if getCompleted {

            choreRef = "Completed chores"
        }
        else {
            print("________Fetching to do!")
        }
        
        if let firID = CoreDataManager.shared.getFamily().firID {
            
                db.collection("Families").document(firID).collection(choreRef).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var newFirChore = Chore(context: CoreDataManager.shared.container.viewContext)

                            newFirChore.choreID = UUID(uuidString: document.documentID)

                            let data = document.data()
                            
                            var timeLimit = data["Timelimit"] as? Double
                            
                            newFirChore.type = data["Type"] as? String ?? ""
                            newFirChore.value = Int64(data["Points"] as? Int ?? 0)
                            
                            
                            newFirChore.dayTodo = data["Day todo"] as? String ?? ""
                            
                            newFirChore.hasTimeLimit = data["Has timelimit"] as? Bool ?? false
                            newFirChore.timeLimit = data["Timelimit"] as? Double ?? 0
                            newFirChore.isCustom = data["isCustom"] as? Bool ?? false
                            newFirChore.doneBy = data["Done by"] as? String ?? ""
                            
                            if getCompleted {
                                var timeStamp = data["Time completed"] as? Timestamp
                                newFirChore.timeCompleted = timeStamp?.dateValue()
                            }
                            if getCompleted {
                                newFirChore.isCompleted = true
                                
                            } else {
                                newFirChore.isCompleted = false
                                newFirChore.doneBy = ""
                            }
                            
                            newFirChores.append(newFirChore)
                        }
                      
                        
                        self.sortChores(newChores: newFirChores, sortCompleted: getCompleted, refresh: refresh)
                       
                    }
                }
        }
    }
    
    func sortChores(newChores: [Chore], sortCompleted: Bool, refresh: Bool){
        print("____SORTING CHORES!!!")
        if refresh {
            print("_____REFRESHING!!!!_______")
            self.choresTodo.removeAll()
        }
        
        for chore in newChores {
            if sortCompleted {
                if self.completedChores.contains(where: { $0.choreID == chore.choreID}) {
                    print("____IS IN COMPLETED!")
                } else {
                    self.completedChores.append(chore)
                }
            } else {
                if self.choresTodo.contains(where: { $0.choreID == chore.choreID}) == false {
                    print("___ADDING NEW CHORE \(choresTodo.count)")
                    print("_____Date: ", chore.dateToDo!)
                    print("_____Weekday: ", chore.dateToDo!.get(.weekday))
                    print("_____WeekdayString",setDay(dateTodo: chore.dateToDo!))
                    print("_______WEEK: ", chore.dateToDo!.get(.weekOfYear))
                    
                    if chore.dateToDo!.get(.weekday) == 1 {
                        print("____WEEK", chore.dateToDo?.get(.weekOfYear))
                        print("____Day", chore.dateToDo?.get(.weekday))
                        if let day = chore.dateToDo {
                            var sunday = Calendar.current.date(byAdding: .day, value: -7, to: day)!
                            print("_____", sunday.get(.weekOfYear))
                            print("____Day", sunday.get(.weekday))
                            chore.dateToDo = sunday
                            do {
                                try chore.save()
                            } catch {
                                print("___ERROR SAVING")
                            }
                        }
                    }

                    self.choresTodo.append(chore)
                }
            }
          
        }
        print("____HAS CHORES!!", choresTodo.count)
        
        print("___TODAY____", Date())
        print("___WEEKDAY____", Date().get(.weekday))
        print("___WEEKOFYEAR____", Date().get(.weekOfYear))
        print("___DAY____", Date().get(.day))
        
        for chore in choresTodo {
            print("_____CHORE DAY:", chore.dayTodo)
            print("_____CHORE DATE:", chore.dateToDo)
            print("_____CHORE DAYINDEX:", chore.dateToDo?.get(.weekday))
            print("_____CHORE WEEK:", chore.dateToDo?.get(.weekOfYear))
        }
        //setCurrentWeek()
    }
    
    func removeChore(chore: Chore){
        print("__REMOVING CHORE: \(chore.choreID)")
        
        if CoreDataManager.shared.getFamily().isConnected == true {
            print("REMOVING FIRCHORE")
            print(chore.choreID)
            self.firHelper.removeChore(firID: CoreDataManager.shared.getFamily().firID ?? "", choreID: chore.choreID!.uuidString)
        }
        CoreDataManager.shared.removeChore(chore: chore)
    }
    
    func setDay(dateTodo: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en")
        
        var dayTodo = dateFormatter.string(from: dateTodo)
        print("_________DAY: ", dayTodo)
        
        return dayTodo
    }
    
    func setCurrentWeek() {
        print("___TODAY____", Date())
        print("___WEEKDAY____", Date().get(.weekday))
        print("___WEEKOFYEAR____", Date().get(.weekOfYear))
        print("___DAY____", Date().get(.day))
        
        if Date().get(.weekday) == 1 {
            print("__SUNDAY!!!")
            currentWeek.append(Date())
        }
        
        var subDay = DateComponents()
        subDay.day = -1
        var addDay = DateComponents()
        subDay.day = 1

        var weekDay = Date()
        
        if weekDay.get(.weekday) == 1 {
            print("__SUNDAY")
            if let newDay = Calendar.current.date(byAdding: addDay, to: weekDay) {
                weekDay = newDay
                print("___weekday: \(weekDay.get(.weekday))")
                
            }
        }
        
        while weekDay.get(.weekday) > 2 {
            if let newDay = Calendar.current.date(byAdding: subDay, to: weekDay) {
                weekDay = newDay
                print("___weekday: \(weekDay.get(.weekday))")
                
            }
        }
        print("___MONDAY: ", weekDay.get(.weekday))
        currentWeek.append(weekDay)
        
        for i in 1...6 {
            print("____i: ", i)
            if let newDay = Calendar.current.date(byAdding: subDay, to: weekDay) {
                weekDay = newDay
                print("__New day: ", newDay.get(.weekday))
                currentWeek.append(weekDay)

            }
        }
        print("____CURRENT WEEK: ", currentWeek.count)
    }
    
    func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
}
