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
    
    func setConnection() async {
        if CoreDataManager.shared.getFamily().isConnected {
            print("IS CONNECTED!!")
            isConnected = true
         
            await getFirChores(getCompleted: false, refresh: false)
            await getFirChores(getCompleted: true, refresh: false)
            
            firHelper.getFirChores(getCompleted: false, refresh: false)
        }
         else {
            print("NOT CONNECTED!!!!!")
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
                if self.choresTodo.contains(where: { $0.choreID == chore.choreID}) {
                    print("_____IS IN TO DO")
                } else {
                    print("___ADDING NEW CHORE \(choresTodo.count)")
                    self.choresTodo.append(chore)
                }
            }
          
        }
        print("HAS CHORES!!")
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
