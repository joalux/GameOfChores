//
//  LoginViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import Foundation
import CoreData
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var hasFamily = false
    @Published var doLogin = false
    @Published var doRegister = false
    @Published var doConnect = false
    
    @Published var showConnectAlert = false

    func getFamily(){
        print("Checking for family!!!")
        hasFamily = CoreDataManager.shared.fetchFamily()
        
        print(hasFamily)
    }
  
    func addFamily(connect: Bool){
        print("Adding new family!!")
        var newFamily = Family(context: CoreDataManager.shared.container.viewContext)
        newFamily.id = UUID()

        do {
            try newFamily.save()

        } catch {
            print("Error saving")
        }
     
    }
    
    
  
    
}
