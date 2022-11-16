//
//  MainView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView {
            TodoView2()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("To do")
                }
            Text("My family")
                .tabItem {
                    Image(systemName: "person.3")
                    Text("My family")
                }
            Text("Planner")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planner")
                }
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape.2")
                    Text("Settings")
                }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
