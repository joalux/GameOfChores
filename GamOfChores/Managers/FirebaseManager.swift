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
    
    private var db = Firestore.firestore()
    
    @Published var firSuccess = false
    @Published var firError = false

    
    var firChores = [Chore]()
    var firMembers = [Member]()
    var firFamily = Family()

    /*
    @MainActor
    func signUp(email: String, pass1: String, pass2: String) async -> Bool{
        do {
            let authResults = try await Auth.auth().createUser(withEmail: email, password: pass1)
            
            let newUser = authResults.user
            print("New user signed in  \(newUser.email ?? "")")
            addFamily(firFam: firFamily)
            firSuccess = true
            
            return firSuccess
            
        }catch {
            print("Error \(error)")
            firSuccess = false
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
    } */
    
    func addFamily(firFam: Family){
        print("ADDING FAM DOC!!!!")
        
        let famMembers = CoreDataManager.shared.getFamilyMembers()
                
        db.collection("Families").document(firFam.firID!).setData([
            "Sinup date": Date(),
            "Mail": firFam.mail
        ])
        
        for member in famMembers {
            print("Adding membo")
            db.collection("Families").document(firFam.firID!).collection("Family members").document(member.id?.uuidString ?? "No id").setData([
                "Name": member.name,
                "Points": member.points,
                "Time": member.time,
                "ChoreCounr": member.choreCount
            ])
            
        }
    }
    
}
