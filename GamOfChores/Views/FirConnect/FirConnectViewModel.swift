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

@MainActor
class FirConnectViewModel: ObservableObject {
        
    //@Published var family = Family(context: CoreDataManager.shared.container.viewContext)
    
    @State var coreFamily = CoreDataManager.shared.getFamily()
        
    @Published var famMembers = [Member]()
    
    private var db = Firestore.firestore()
        
    @Published var famMail = ""
    @Published var famPass = ""
    @Published var famPass2 = ""
    
    @Published var firID = ""
        
    @Published var resultString = ""
    
    @Published var isConnected = false

    @Published var createFam = false
    @Published var connectFam = true
    
    @Published var firLoading = false
    @Published var firSuccess = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var firError = false

    @Published var doConnect = false
    @Published var doRegister = false
    
    @Published var inSettings = false
    
    @Published var showInvalidPassAlert = false
    @Published var showShortPassAlert = false

    @Published var showConnectAlert = false
    @Published var showJoinAlert = false

    @Published var showDisconnectDevAlert = false
    @Published var showDisconnectFamAlert = false
    
    @Published var showingAlert = false

        
    init(){
        print("INITTING FIRMODEL!!!!!!!!")
        print("IS CONNECTED = \(coreFamily.isConnected)")
    }
    
    func connectFamily() {
        firLoading = true
        print("CONNECTING FAMILY!!")
        print(coreFamily.familyID)
        print(coreFamily.isConnected)
        if createFam {
            Auth.auth().createUser(withEmail: famMail, password: famPass){ authResults, error in
                guard error == nil else {
                    self.firLoading = false
                    self.resultString = error!.localizedDescription
                    print("_AUTH _ \(authResults)___ERROR : \(error)")
                    self.firError = true
                    return
                }
                print("NO ERROR")
                print("User created")
                if let user = Auth.auth().currentUser {
                    print("___CONNECTING FAM, USERID = \(user.uid), \(user.email)")
                    self.coreFamily.isConnected = true
                    self.coreFamily.firID = user.uid
                    self.coreFamily.mail = user.email
                    
                    CoreDataManager.shared.connectFamily(firID: user.uid, mail: self.famMail, addNew: true)
                    if self.firSuccess == FireBaseHelper.shared.addFamily(firID: user.uid, mail: self.famMail) {
                        print("You are now connected!")
                        self.firSuccess = true
                        self.resultString = "You are now connected!"
                        

                    }
                    
                    

                }
            }
        }
        
    }
    
    func connect(members: [Member] = [Member](), chores: [Chore] = [Chore]()) {
        firLoading = true
        print("SIGNING UP!!!!!!")
        if createFam {
            
            Auth.auth().createUser(withEmail: famMail, password: famPass){ authResults, error in
                guard error == nil else {
                    self.firLoading = false
                    self.resultString = error!.localizedDescription
                    print("_AUTH _ \(authResults)___ERROR : \(error)")
                    self.firError = true
                    return
                }
                print("NO ERROR")
                print("User created")
                if let user = Auth.auth().currentUser {
                    print("___CONNECTING FAM, USERID = \(user.uid), \(user.email)")
                    self.coreFamily.isConnected = true
                    self.coreFamily.firID = user.uid
                    self.coreFamily.mail = user.email
                    
                    CoreDataManager.shared.connectFamily(firID: user.uid, mail: self.famMail, addNew: true)

                    for member in members {
                        if let name = member.name {
                           print("Adding firmember!!!!")
                            FireBaseHelper.shared.addNewFirMember(firID: user.uid, memberID: UUID().uuidString, firName: name)
                            
                        }
                    }
                    
                    for chore in chores {
                        if chore.isCompleted {
                            print("Adding completed chore")
                            FireBaseHelper.shared.completeChore(firID: user.uid, firChore: chore)

                        }
                        else {
                            FireBaseHelper.shared.addChore(firID: user.uid, firChore: chore)

                        }
                    }
                    self.resultString = "You are now connected!"
                    self.firSuccess = true
                }
                   
            }
            
        }
    
        else {
            print("JOINGING FAMILY")
            Auth.auth().signIn(withEmail: famMail, password: famPass) { authResult, error in
                guard error == nil else {
                    self.firLoading = false
                    print("_AUTH _ \(authResult)___ERROR : \(error)")
                    self.resultString = error!.localizedDescription
                    self.firError = true
                    return
                }
                
                print("NO ERROR")
                print("User signed in!!")
                if let user = Auth.auth().currentUser {
                    print("___CONNECTING FAM, USERID = \(user.uid), \(user.email)")
                    self.coreFamily.isConnected = true
                    self.coreFamily.firID = user.uid
                    self.coreFamily.mail = user.email
                    
                    self.resultString = "You are now connected!"
                    self.firSuccess = true

                }
                
                /*switch authResult {
                case .none:
                    print("__Could not sign in")
                    self.resultString = "Sign in failed"
                    self.firError = true
                case .some(_):
                    print("___SIGN IN SUCCESS!!")
                    
                    print("___CONNECTING CORE FAM \(authResult?.user.uid)")
                    if let userID = authResult?.user.uid {
                        CoreDataManager.shared.connectFamily(firID: userID, mail: self.famMail, addNew: false)
                    }

                    self.firSuccess = true
                }*/
            }
        }
    }
    
    func getFamilyMembers(firID: String){

        print("GETTING FIRFAMILY!!!!")
        print(firID)
        
        db.collection("Families").document(firID).collection("Family members").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    print("Setting ")
                    
                    let userID = UUID()
                    var firName = data["Name"] as? String ?? ""
                    var firPoints = Int64(data["Points"] as? Int ?? 0)
                    var firTime = data["Time"] as? Double ?? 0
                    var fitCount = Int64(data["ChoreCount"] as? Int ?? 0)
                    
                    self.famMembers.append(CoreDataManager.shared.setMember(id: userID, firID: document.documentID, name: firName, points: Int(firPoints), time: firTime, choreCount: fitCount))
                    
                }
            }
        }
        
        db.collection("Families").document(firID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func disconnectDevice() {
        coreFamily.isConnected = false
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
        FireBaseHelper.shared.removeFamily(firID: coreFamily.firID ?? "No id")
    
        coreFamily.isConnected = false
        CoreDataManager.shared.save()
    }
}
