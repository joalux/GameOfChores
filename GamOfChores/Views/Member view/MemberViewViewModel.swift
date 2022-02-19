//
//  MemberViewViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-12.
//

import Foundation
import SwiftUI
import CoreData

class MemberViewViewModel: ObservableObject {
    
    var selectedMember: Member?

    @Published var completedChores = [Chore]()
    
    func getCompleted(){
        print("________Fetching user chores!!")
        var allChores = CoreDataManager.shared.getChores()
        
        for chore in allChores {
            print("__Done by")
            print(chore.doneBy ?? "no memebers")
            
            var doneBy = chore.doneBy!.components(separatedBy: ",")
         
            
            //doneBy.removeLast()
            print("Done by count= \(doneBy.count)")
            print("Done by = \(doneBy)")
            
            print(selectedMember!.name!)
            if doneBy.contains(selectedMember!.name!){
                print("HAS DONE IT!!!")
                completedChores.append(chore)
                print("Complete count: \(completedChores.count)")
            }
            
        }
    }
}
