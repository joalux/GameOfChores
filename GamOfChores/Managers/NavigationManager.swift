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
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func goToStart() {
        print("goingd to start!!")
        path.append(Destination.startMenuView)
    }
    func goToAddFamily() {
        print("goingd to add fam!!")
        path.append(Destination.addFamilyView)
    }
    func goToFirConnect() {
        print("goingd to firconnect!!")
        path.append(Destination.firConnectView)
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
            
        }
    }
}
