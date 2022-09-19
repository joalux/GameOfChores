//
//  SettingsViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-19.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SettingsViewModel: ObservableObject {
    
    @Published var showConnectAlert = false
    @Published var showResetAlert = false
    
    @Published var showResetTodoAlert = false
    @Published var showResetCompletedAlert = false

    @Published var doConnect = false
    @Published var manageFamily = false
        
    func signOut(){
        CoreDataManager.shared.deleteFamily()
    }
    
    func connectFamily(){
        print("Connecting family")
    }
    
    func resetFamily() {
        print("Resetting family, Connected = \(CoreDataManager.shared.getFamily().isConnected)")
        
        CoreDataManager.shared.resetFamily()
        
        if CoreDataManager.shared.getFamily().isConnected {
            print("Fam is connected!!")
            let firID = CoreDataManager.shared.getFamily().firID ?? "No ID!!!"
            FireBaseHelper.shared.resetFamily(firID: firID)
        }
    }
    
    func resetChores(resetTodo: Bool) {
        print("Resetting chores!!!")
        let coreFam = CoreDataManager.shared.getFamily()
        CoreDataManager.shared.removeAllChores(deleteTodo: resetTodo)
        
        if coreFam.isConnected {
            print("resetting firchores!!")
            FireBaseHelper.shared.removeAll(firID: coreFam.firID ?? "No id", resetToDo: resetTodo)
        }
        
    }
    
}
