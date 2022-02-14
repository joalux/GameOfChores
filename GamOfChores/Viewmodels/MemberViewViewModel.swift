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

    @State var completedChores = [Chore]()
    
    func getCompleted(){
        print("________Fetching user chores!!")
        var allChores = CoreDataManager.shared.fetchChores()
        
        for chore in allChores {
            print("__Done by")
            print(chore.doneBy ?? "no memebers")
            
            var doneBy = chore.doneBy!.components(separatedBy: ",")
            
            for member in doneBy {
                print(member)
            }
            doneBy.removeLast()
            print("Done by count= \(doneBy.count)")
            
            for name in doneBy {
                print(name)
                print(selectedMember!.name!)
                if name.contains(selectedMember!.name!){
                    print("HAS DONE IT!!!")
                    completedChores.append(chore)
                }
            }
        }
    }
}
