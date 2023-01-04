//
//  LoginView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var navManager: NavigationManager
    
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
            VStack(spacing: 0) {
                
                Image("GOCTITLE")
                    .resizable()
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .frame(width: 350, height: 250)
                    .scaledToFit()
                
                Button(action: {
                    CoreDataManager.shared.deleteFamily()

                   // vm.addFamily()
                    vm.showConnectAlert = true
                }, label: {
                    Text(LocalizedStringKey("Begin"))
                        .padding()
                        .frame(width: 200.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom, 70)
                    .alert(isPresented:$vm.showConnectAlert) {
                        Alert(
                            title: Text(LocalizedStringKey("WantToConnect")),
                            message: Text(LocalizedStringKey("WantToConnectMessage")),
                            primaryButton: .default(Text(LocalizedStringKey("Yes")), action: {
                                print("Connecting!!!")
                                navManager.goToFirConnect()
                                
                            }),
                            secondaryButton: .default(Text(LocalizedStringKey("No")), action: {
                                print("no connect!!")
                                navManager.goToAddFamily()

                            })
                        )
                    }
                
            }
            .onAppear {
               // vm.getFamily()
                if vm.hasFamily {
                    print("HAS FAMILY!!!!")
                    navManager.goToStart()
                }
            }
            .toolbar(.hidden)
          
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
