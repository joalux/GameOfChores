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

    @Published var monday = [Chore]()
    @Published var tuesday = [Chore]()
    @Published var wednesday = [Chore]()
    @Published var thursday = [Chore]()
    @Published var friday = [Chore]()
    @Published var saturday = [Chore]()
    @Published var sunday = [Chore]()
    @Published var noDay = [Chore]()
    
    @Published var selectedDay = "Monday"
    
    @Published var selectedType = "Dishes"
    

    func fetchChores() {
        print("____Fetching chores to template!!")
        templateChores = CoreDataManager.shared.getChores()
        
        for chore in templateChores {
            if chore.isTemplate {
                print("____CHORE IS TEMPLATE DAY = \(chore.dayTodo)")
                if let dayTodo = chore.dayTodo {
                    print("DAY = \(dayTodo)")
                    if dayTodo == "Monday" {
                        print("ADDING MONDAY")
                        monday.append(chore)
                    }
                    else if dayTodo == "Tuesday" {
                        tuesday.append(chore)
                    }
                    else if dayTodo == "Wednesday" {
                        wednesday.append(chore)
                    }
                    else if dayTodo == "Thursday" {
                        thursday.append(chore)
                    }
                    else if dayTodo == "Friday" {
                        friday.append(chore)
                    }
                    else if dayTodo == "Saturday" {
                        saturday.append(chore)
                    }
                    else if dayTodo == "Sunday" {
                        sunday.append(chore)
                    }
                }
            }
        }
        print("____HAS TEMPLATE CHORES!!!!")
        sortChores()
    }
        
    func sortChores(){
        print(" \n ___SORTING CHORES \(templateChores.count) chores!")
        for chore in templateChores {
            if let dayTodo = chore.dayTodo {
                print(dayTodo)
                if dayTodo == "Monday" {
                    if monday.contains(chore) == false {
                        print("___Adding to monday")
                        monday.append(chore)
                        print("___To do monday \(monday.count)")
                    }
                }
                else if dayTodo == "Tuesday" {
                    tuesday.append(chore)
                }
                else if dayTodo == "Wednesday" {
                    print("___To do Wednesday")
                    wednesday.append(chore)
                }
                else if dayTodo == "Thursday" {
                    print("___To do Thursday")
                    thursday.append(chore)
                }
                else if dayTodo == "Friday" {
                    print("___To do Thursday")
                    friday.append(chore)
                }
                else if dayTodo == "Saturday" {
                    print("___To do Saturday")
                    saturday.append(chore)
                }
                else if dayTodo == "Sunday" {
                    print("___To do Sunday")
                    sunday.append(chore)
                }
            }
        }
    }
    
    func getDayChores(dayTodo: String) -> [Chore]{
        print("_____GETTING DAYCHORES = \(dayTodo)")
        if dayTodo == "Monday" {
            print("___GETTING MONDAY \(monday.count)")
            print("___Monday")
            return monday
        }
        else if dayTodo == "Tuesday" {
            print("____GETTING TUESDAY \(tuesday.count)")
            print("___Tuesday")
            return tuesday
        }
        else if dayTodo == "Wednesday" {
            print("___Wednesday")
            return wednesday
        }
        else if dayTodo == "Thursday" {
            print("___Thursday")
            return thursday
        }
        else if dayTodo == "Friday" {
            print("___Thursday")
            return friday
        }
        else if dayTodo == "Saturday" {
            print("___Saturday")
            return saturday
        }
        else if dayTodo == "Sunday" {
            print("___Sunday")
            return sunday
        }
        print("NO CHORES DAY")
        return templateChores
    }
    
    func saveTemplate() {
        print("____Saving template!!")
        
        
        
        if CoreDataManager.shared.getFamily().isConnected {
            print("__IS CONNECTED!!")
            print("")
        }
    }
    
   
}
