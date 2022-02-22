//
//  ManageFamilyView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-17.
//

import SwiftUI

struct ManageFamilyView: View {
    
    @State var showManageFamily = false
    @State var showManageMembers = false
    @State var showManageChores = false
    
    @StateObject var vm = SettingsViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationLink(destination: FirConnectView(), isActive: self.$vm.doConnect) {
                EmptyView()
            }.hidden()
            
            NavigationLink(destination: AddFamilyView(), isActive: self.$vm.manageFamily) {
                EmptyView()
            }.hidden()
            
            Button(action: {
                vm.showResetAlert = true
            }, label: {
                Text("Reset family")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .alert(isPresented:$vm.showResetAlert) {
                    Alert(
                        title: Text("Reset?"),
                        message: Text("Do you want to reset? All points and time will be set to zero and all chores will be removed."),
                        primaryButton: .destructive(Text("Yes"), action: {
                            print("Connecting!!!")
                            vm.resetFamily()
                            
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            print("no reset!!")
                        })
                    )
                }
            
            
            Button(action: {
                vm.manageFamily = true
            }, label: {
                Text("Manage members")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
        }
    }
}

struct ManageFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFamilyView()
    }
}
