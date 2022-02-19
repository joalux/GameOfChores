//
//  FirConnectViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-14.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirConnectViewModel: ObservableObject {
    
    var db = Firestore.firestore()
    
    @Published var firFamily = Family()

    @Published var famMail = ""
    @Published var famPass = ""
    @Published var famPass2 = ""
    
    @Published var resultString = ""
    
    @Published var createFam = false
    @Published var connectFam = false
    
    @Published var firLoading = false
    @Published var firSuccess = false
    @Published var firError = false

    @Published var doConnect = false
    @Published var doRegister = false
    
    @Published var showAlert = false

    @Published var showDisconnectDevAlert = false
    @Published var showDisconnectFamAlert = false

    func connectFamily() {
        
    }
    
    func disconnectFamily() {
        
    }
}
