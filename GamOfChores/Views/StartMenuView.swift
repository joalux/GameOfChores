//
//  StartMenuView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-11.
//

import SwiftUI

struct StartMenuView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject var coreManager = CoreDataManager()
    
    @State var isNavigationBarHidden = true
        
    @State var goChores = false
    @State var goFamily = false
    @State var goPlanner = false
    @State var goSettings = false
    
    var body: some View {
        
        VStack(spacing: 15) {
                
                NavigationLink(destination: TodoView(), isActive: $goChores) { EmptyView() }
                
                NavigationLink(destination: FamilyView(), isActive: $goFamily) { EmptyView() }

                NavigationLink(destination: PlannerView(), isActive: $goPlanner) { EmptyView() }
                
                NavigationLink(destination: SettingsView(), isActive: $goSettings) { EmptyView() }

                Button {
                    goChores = true
                } label: {
                    Text("Chores")
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    goFamily = true
                } label: {
                    Text(LocalizedStringKey("MyFamily"))
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    goPlanner = true
                } label: {
                    Text(LocalizedStringKey("Planner"))
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    goSettings = true
                } label: {
                    Text(LocalizedStringKey("Settings"))
                        .frame(width: 190.0, height: 45.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.top)
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = true
            }
    }
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}
