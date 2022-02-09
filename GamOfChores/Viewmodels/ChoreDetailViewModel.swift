//
//  ChoreDetailViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-15.
//

import Foundation
import CoreData
import SwiftUI

class ChoreDetailViewModel: ObservableObject {

    @Published var selectedChore = Chore()
    
    @Published var familyMembers = [Member]()
    
    
    
    var timer = Timer()
    
    enum timerhMode {
        case running
        case stopped
        case paused
    }
    
    @Published var minutes = 0
    @Published  var seconds = 0
    @Published  var timeSpent = 0

    @Published var buttonText = "Start"
    @State var isCustom = false
    @Published var isCounting = false
    @Published var hasStarted = false
    @State var hasTimeLimit = false
    @Published var hasEnded = false
    @Published var hasCompleted = false

    
    func getFamily(){
        familyMembers = CoreDataManager.shared.getFamilyMembers()

    }
    
    func setTimer(reset: Bool){
        
        if reset {
            restartTimer()
        }
        else {
            if isCounting {
                pauseTimer()
            }
            else {
                startTimer(resume: hasStarted)
            }
        }
     
    }
    
    func startTimer(resume: Bool){
        isCounting = true
        hasStarted = true
        buttonText = "Pause"
        print("START Time limit ========= \(selectedChore.timeLimit)")
        if resume == false{
            minutes = Int(selectedChore.timeLimit)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: isCounting){ tempTimer in
            
            print(self.seconds)
            
            if self.selectedChore.hasTimeLimit {
                self.seconds -= 1
                if self.seconds <= 0 {
                    print("ONE MINUTE!!!!")
                    self.timeSpent += 1
                    self.minutes -= 1
                    self.seconds = 59
                    if self.minutes <= 0 {
                        self.hasEnded = true
                    }
                }
            }
            else {
                self.seconds += 1
                if self.seconds >= 60 {
                    print("ONE MINUTE!!!!")
                    self.timeSpent += 1
                    self.minutes += 1
                    self.seconds = 0

                }

            }
        }
    }
    
    func pauseTimer(){
        print("____Pausing timer!!!")
        buttonText = "Start"
        timer.invalidate()
        isCounting = false
    }
    
    func restartTimer(){
        print("____Restarting timer!!!")

        buttonText = "Start"
        timer.invalidate()
        isCounting = false
        hasStarted = false
        if selectedChore.hasTimeLimit {
            minutes = Int(selectedChore.timeLimit)
        }
        else {
            minutes = 0
        }
        seconds = 0
    }
    
    func completeChore(selectedMembers: Set<Member>){
        print("____COMPLETEING CHORE!!!")
        timer.invalidate()
        selectedChore.isCompleted = true
        selectedChore.timeSpent = Double(timeSpent)
        
        for member in selectedMembers {
            print("MEMBER: \(member.name), \(member.isSelected)")
          
            print("Adding points to: \(member.name)")
            member.points += selectedChore.value
            member.time += Double(timeSpent)
            
            do {
                try member.save()
            } catch  {
                print("Error saving!!!!")
            }
            
        }
        
        do {
           try selectedChore.save()
        } catch  {
            print("Error saving!!!!")
        }
        hasCompleted = true

    }
}
