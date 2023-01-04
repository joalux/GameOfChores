//
//  StartMenuView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-11.
//

import SwiftUI

struct StartMenuView: View {
    
    @EnvironmentObject var navManager: NavigationManager
        
    var body: some View {
        
        VStack(spacing: 15) {
                
                Button {
                    navManager.goToToDo()
                } label: {
                    Text("Chores")
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    navManager.goToFamily()
                } label: {
                    Text(LocalizedStringKey("MyFamily"))
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    navManager.goToPlanner()
                } label: {
                    Text(LocalizedStringKey("Planner"))
                        .frame(width: 220.0, height: 55.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    navManager.goToSettings()
                } label: {
                    Text(LocalizedStringKey("Settings"))
                        .frame(width: 190.0, height: 45.0, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.top)
            .navigationBarHidden(true)
            .onAppear {
                print(navManager.path.count)
            }
    }
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}
