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
        
    @Published var family = Family(context: CoreDataManager.shared.container.viewContext)
    
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
    
    @Published var inSettings = false
    
    @Published var showAlert = false
    @Published var showInvalidPassAlert = false

    @Published var showConnectAlert = false
    @Published var showDisconnectDevAlert = false
    @Published var showDisconnectFamAlert = false
    
    init(){
        print("INITTING FIRMODEL!!!!!!!!")
        family = CoreDataManager.shared.getFamily()
        print(family.isConnected)
    }
    
    func test(){
        firSuccess = true
    }
    
    @MainActor
    func connect(create: Bool) async -> Bool{
        do {
            firLoading = true
            
            if create {
                let authResults = try await Auth.auth().createUser(withEmail: famMail, password: famPass)
                let newUser = authResults.user
                print("New user is created  \(newUser.email ?? "")")
            }
            else {
                let authResults = try await Auth.auth().signIn(withEmail: famMail, password: famPass)
                let activeUser = authResults.user
                print("USER IS SIGNED in  \(activeUser.email ?? "")")

            }
            
           
            firSuccess = true
            isConnected = true
            
            family.isConnected = true
            
            return firSuccess
           
        }catch {
            print("Error \(error)")
            firError = true
            return firError
        }
        
    }
    
    func signUp2() async{
        
        
        
        
        
        print("Creating new user: \(famMail), \(famPass), \(famPass2),")
        isConnected = await firManager.signUp(email: famMail, pass1: famPass, pass2: famPass2)
        /*
        let newTask = Task { () -> Bool in
            let success = await FireBaseManager.shared.signUp(email: famMail, pass1: famPass, pass2: famPass2)

            return success
        }
        
        async {
              await FireBaseManager.shared.signUp(email: famMail, pass1: famPass, pass2: famPass2)
           
            print("user is signed in as ")
        }*/
    }
 
    func connectFamily() {
        print("Connecting family")
               
        showConnectAlert = true
        family.isConnected = true
        CoreDataManager.shared.save()
    }
    
    func disconnectFamily() {
        
        print("disConnecting family")
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
              print("Error deleting: \(error)")
          } else {
            // Account deleted.
              print("Family has disconnected!")
          }
        }
        
        family.isConnected = false
        CoreDataManager.shared.save()
    }
}
