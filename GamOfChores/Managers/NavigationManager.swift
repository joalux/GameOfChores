//
//  NavigationManager.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-12-06.
//

import Foundation
import SwiftUI

enum Destination {
    case loginView
    case addFamilyView
    case firConnectView
    case startMenuView
    case toDoView
    case familyView
    case plannerView
    case settingsView
    case addChoreView
    
}

public class Router<T: Hashable>: ObservableObject {
    @Published var paths: [T] = []
    
    func push(_ path: T) {
        paths.append(path)
    }
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func goToStart(){
        print("goingd to start!!")
        path.append(Destination.startMenuView)
    }
    func goToAddFamily(){
        print("goingd to add fam!!")
        path.append(Destination.addFamilyView)
    }
    func goToFirConnect(){
        print("goingd to firconnect!!")
        path.append(Destination.firConnectView)
    }
    func goToToDo(){
        print("going to todo!!")
        path.append(Destination.toDoView)
    }
    func goToAddChore(){
        print("Going to add chore!!")
        path.append(Destination.addChoreView)
    }
    func goToFamily(){
        print("Going to my family!!")
        path.append(Destination.familyView)
    }
    func goToSettings(){
        print("Going to my settings!!")
        path.append(Destination.settingsView)
    }
    func goToPlanner(){
        print("Going to my planner!!")
        path.append(Destination.plannerView)
    }
}

class ViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .loginView:
            LoginView()
        case .addFamilyView:
            AddFamilyView()
        case .firConnectView:
            FirConnectView()
        case .startMenuView:
            StartMenuView()
        case .toDoView:
            TodoView()
        case .familyView:
            FamilyView()
        case .plannerView:
            PlannerView2()
        case .settingsView:
            SettingsView()
        case .addChoreView:
            AddChoreView()
        }
    }
}
