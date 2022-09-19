//
//  LoginView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                NavigationLink(destination: StartMenuView(), isActive: $vm.hasFamily) {
                    EmptyView()
                }.hidden()
                
                NavigationLink(destination: AddFamilyView(), isActive: $vm.doRegister) {
                    EmptyView()
                }.hidden()
                
                NavigationLink(destination: FirConnectView(), isActive: self.$vm.doConnect) {
                    EmptyView()
                }.hidden()
                
                
                Image("GOCTITLE")
                    .resizable()
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .frame(width: 350, height: 250)
                    .scaledToFit()
                
                Button(action: {
                    
                    vm.showConnectAlert = true
                    //vm.addFamily(connect: true)
                    
                }, label: {
                    Text(LocalizedStringKey("Begin"))
                        .padding()
                        .frame(width: 200.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom, 70)
                
            }.alert(isPresented:$vm.showConnectAlert) {
                Alert(
                    title: Text(LocalizedStringKey("WantToConnect")),
                    message: Text(LocalizedStringKey("WantToConnectMessage")),
                    primaryButton: .default(Text(LocalizedStringKey("Yes")), action: {
                        print("Connecting!!!")
                        vm.addFamily(connect: true)
                        
                    }),
                    secondaryButton: .default(Text(LocalizedStringKey("No")), action: {
                        print("no connect!!")
                        vm.addFamily(connect: false)
                        
                    })
                )
            }
            .onAppear {
                 vm.getFamily()
            }
            
        }.navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
