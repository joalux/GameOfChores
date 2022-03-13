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

@MainActor class FirConnectViewModel: ObservableObject {
        
    @Published var family = Family(context: CoreDataManager.shared.container.viewContext)
    
   // @StateObject var firManager = FireBaseManager()
    
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
    
    
    func connect(create: Bool) async -> Bool{
        do {
            firLoading = true
            
            if create {
                let authResults = try await Auth.auth().createUser(withEmail: famMail, password: famPass)
                let newUser = authResults.user
                print("New user is created  \(newUser.email ?? "")")
                family.firID = newUser.uid
            }
            else {
                let authResults = try await Auth.auth().signIn(withEmail: famMail, password: famPass)
                let activeUser = authResults.user
                print("USER IS SIGNED in  \(activeUser.email ?? "")")
                family.firID = activeUser.uid
                

            }
            
           
            firSuccess = true
            isConnected = true
            
            family.mail = famMail
            family.isConnected = true
            
            FireBaseManager.shared.addFamily(firFam: family)
            
            do {
                try family.save()
                print("Save success!")
            }
            catch {
                print("Error saving")
            }
            
            return firSuccess
           
        }catch {
            print("Error \(error)")
            
            resultString = error.localizedDescription
            
             firError = true
            return firError
        }
        
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
