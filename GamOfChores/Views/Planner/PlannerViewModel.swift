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
    
    var weekDays = ["Mon", "Tu", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var weekDaysFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
    var weekChores = [[Chore()], [Chore()], [Chore()], [Chore()], [Chore()], [Chore()], [Chore()]]
    
    private var db = Firestore.firestore()
    
    @StateObject var coreManager = CoreDataManager()
    
    @ObservedObject var todoVM = TodoViewModel()
    
    @Published var chores = [Chore]()
    
    @Published var family = Family()
    
    @State var currentDayIndex = 0
    @Published var dayIndeces = 0...6
        
    @Published var selectedDay = ""
    
    @Published var isConnected = false
    
    init() {
        
        setConnection()
        
        getDayIndex()
        getWeekIndex()
    }
    
    func setConnection() {
        family = CoreDataManager.shared.getFamily()
        if family.isConnected {
            isConnected = true
            getFirChores()
        }
         else {
            isConnected = false
            getCoreChores()
        }
    }
    
    func getCoreChores() {
        chores = CoreDataManager.shared.getChores()
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
                    }
                }
            
        }
    }
    
    func getDayIndex() -> Int{
        currentDayIndex = Calendar.current.component(.weekday, from: Date())
        currentDayIndex -= 1

        return currentDayIndex
    }
    func getWeekIndex() {
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        print("________WEEK == \(weekOfYear)")
    }
}
