//
//  FirebaseManager.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import Foundation
import Firebase


class FireBaseManager: ObservableObject {
    
    static let shared = FireBaseManager()
    
    private var firStore = Firestore.firestore()
    
    var firChores = [Chore]()
    var firMembers = [Member]()
    var firFamily = Family()
    
    func signUp(email: String, pass1: String, pass2: String) {
        // [START create_user]
             Auth.auth().createUser(withEmail: email, password: pass1) { authResult, error in
               // [START_EXCLUDE]
                 guard let user = authResult?.user, error == nil else {
                   print("Error signing up!")
                     return
                 }
                 print("\(user.email!) created")
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
