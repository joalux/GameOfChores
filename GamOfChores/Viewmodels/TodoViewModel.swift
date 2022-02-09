//
//  TodoViewModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class TodoViewModel: NSObject, ObservableObject {
    
    @StateObject var coreManager = CoreDataManager()
    
    @Published var chores = [Chore]()
    @Published var dayTodo = ""
    
     func fetchChores(){
        chores = CoreDataManager.shared.fetchChores()
         for chore in chores {
             print(chore.type)
             print(chore.isCompleted)
             print(chore.dayTodo)
         }
    }
   
    func removeChore(chore: Chore){
        do{
            try chore.delete()
        } catch {
            print("ERROR DELETEING")
            print(error.localizedDescription)
        }
        fetchChores()
    }
    
}

extension TodoViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("__________DID CHANGE CONTENT___________")
        guard let chores = controller.fetchedObjects as? [Chore] else {
            return
        }
        
        self.chores = chores
    }
}
