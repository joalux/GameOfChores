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
        
    @Published var family = Family()
    
    @StateObject var firManager = FireBaseManager()
    
    @Published var famMail = ""
    @Published var famPass = ""
    @Published var famPass2 = ""
    
    @Published var resultString = ""
    
    @Published var isConnected = false

    @Published var createFam = false
    @Published var connectFam = false
    
    @Published var firLoading = false
    @Published var firSuccess = false
    @Published var firError = false

    @Published var doConnect = false
    @Published var doRegister = false
    
    @Published var showAlert = false
    @Published var showInvalidPassAlert = false


    @Published var showConnectAlert = false
    @Published var showDisconnectDevAlert = false
    @Published var showDisconnectFamAlert = false
    
    init(){
        family = CoreDataManager.shared.getFamily()
        print(family.isConnected)
    }
    
    func signUp(){
        
        print("Creating new user: \(famMail), \(famPass), \(famPass2),")
        
        firLoading = true
        
        if famPass != famPass2 {
            print("No maatch!!")
            showInvalidPassAlert = true
            return
        }
        else {
            Auth.auth().createUser(withEmail: famMail, password: famPass) { authResult, error in
                guard let newUser = authResult?.user, error == nil else {
                    print(error?.localizedDescription)
                    self.firError = true
                    return
                }
                print("\(newUser.email!) created")
             
                self.firSuccess = true
                self.firLoading = false
            }
        }
    }
 
    func connectFamily() {
        print("Connecting family")
               
        showConnectAlert = true
        family.isConnected = true
        CoreDataManager.shared.save()
    }
    
    func disconnectFamily() {
        
        print("disConnecting family")
        family.isConnected = false
        CoreDataManager.shared.save()
    }
}
