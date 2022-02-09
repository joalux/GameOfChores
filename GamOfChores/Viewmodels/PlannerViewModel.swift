//
//  PlannerViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-23.
//

import Foundation
import CoreData
import SwiftUI

class PlannerViewModel: ObservableObject {
    
    var weekDays = ["Mon", "Tu", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var weekDaysFull = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    @StateObject var coreManager = CoreDataManager()
    
    @Published var chores = [Chore]()
    
    @Published var currentDayIndex = 0
    @Published var dayIndeces = 0...6
    
    @Published var selectedDay = ""
    
    init(){
        fetchChores()
    }
    
    func fetchChores(){
        chores = CoreDataManager.shared.fetchChores()
       
    }
    
    func getDayOfWeek() {
        currentDayIndex = Calendar.current.component(.weekday, from: Date())
        print("________")
        
        currentDayIndex -= 1
        
        print(currentDayIndex)
        
    }
    
    /*
    func removeChore(chore: Chore){
        do{
            try chore.delete()
        } catch {
            print("ERROR DELETEING")
            print(error.localizedDescription)
        }
        fetchChores()
    } */
}
