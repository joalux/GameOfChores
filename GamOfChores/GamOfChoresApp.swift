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
    
    init(){
        print("initting!!!")
        FirebaseApp.configure()
    }
    var body: some Scene {
        
        WindowGroup {
           let context = CoreDataManager.shared.container.viewContext

            StartMenuView()
               .environment(\.managedObjectContext, context)

            
           // TodoView(vm: TodoViewModel(context: context))
             //   .environment(\.managedObjectContext, context)
        }
    }
}
