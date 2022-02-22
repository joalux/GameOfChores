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

    @Published var doConnect = false
    
    func signOut(){
        CoreDataManager.shared.deleteFamily()
    }
    
    func connectFamily(){
        print("Connecting family")
    }
    
    func resetFamily() {
        print("Resetting family")
    }
    
}
