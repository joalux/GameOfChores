//
//  FirebaseManager.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import Foundation
import Firebase
import SwiftUI

class FireBaseManager: ObservableObject {
    
    static let shared = FireBaseManager()
    
    private var firStore = Firestore.firestore()
    
    @Published var firSuccess = false
    @Published var firError = false

    
    var firChores = [Chore]()
    var firMembers = [Member]()
    var firFamily = Family()

    @MainActor
    func signUp(email: String, pass1: String, pass2: String) async -> Bool{
        do {
            let authResults = try await Auth.auth().createUser(withEmail: email, password: pass1)
            
            let newUser = authResults.user
            print("New user signed in  \(newUser.email ?? "")")
            firSuccess = true
            
            return firSuccess
            /*
            { authResult, error in
                guard let newUser = authResult?.user, error == nil else {
                    print(error?.localizedDescription)
                    self.firError = true
                    return
                }
                print("\(newUser.email!) created")
                self.firSuccess = true
                
            }*/
            
        }catch {
            print("Error \(error)")
            return firSuccess
        }
        
    }
    
    func signIn(email: String, pass: String) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
               if let error = error {
                   print("Error signing in: \(error)")
                   
               } else {
                   print("signup success!!")
               }
           }
    }
    
}
