//
//  GamOfChoresApp.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-02.
//

import SwiftUI
import Firebase

@main
struct GamOfChoresApp: App {
    
    @ObservedObject var navigationManager = NavigationManager()
    
    init(){
        print("initting!!!")
        FirebaseApp.configure()
    }
    var body: some Scene {
        
        WindowGroup {
           let context = CoreDataManager.shared.container.viewContext

            NavigationStack(path: $navigationManager.path) {
                LoginView()
                    .navigationDestination(for: Destination.self) { destination in
                        ViewFactory.viewForDestination(destination)
                    }
            }
            
            .environmentObject(navigationManager)

        }
    }
}
