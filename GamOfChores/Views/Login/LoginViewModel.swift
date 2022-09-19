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
    }
  
    func addFamily(connect: Bool){
        CoreDataManager.shared.addCoreFamily()
                     
        if connect {
            doConnect = true
        } else {
            doRegister = true
        }
        
    }
    
    
  
    
}
