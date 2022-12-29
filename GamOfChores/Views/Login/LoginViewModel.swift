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
    
    @Published var activeFamily = Family()
    
    func getFamily(){
        print("Getting fam!!")
        hasFamily = CoreDataManager.shared.fetchFamily()
        
        if hasFamily {
            activeFamily = CoreDataManager.shared.getFamily()
            
            print("FAM:", activeFamily.familyID)
        }
        else {
            print("NO FAM!!")
        }
    }
  
    func addFamily(){
        CoreDataManager.shared.addCoreFamily()
        
    }
    
    
  
    
}
