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
                    
                }, label: {
                    Text("Begin")
                        .padding()
                        .frame(width: 200.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom, 70)
                
            }.alert(isPresented:$vm.showConnectAlert) {
                Alert(
                    title: Text("Do you want to connect?"),
                    message: Text("You can connect to an existing family or create a new for your family to connct to."),
                    primaryButton: .default(Text("Yes"), action: {
                        print("Connecting!!!")
                        vm.addFamily(connect: true)
                        vm.doConnect = true
                        
                    }),
                    secondaryButton: .default(Text("No"), action: {
                        print("no connect!!")
                        vm.addFamily(connect: false)
                        vm.doRegister = true
                        
                    })
                )
            }
            .onAppear {
                // vm.getFamily()
            }
            
        }.navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
