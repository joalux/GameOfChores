//
//  LoginView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import SwiftUI

struct LoginView: View {
    @State var path = NavigationPath()

    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            VStack(spacing: 0) {
                
                Image("GOCTITLE")
                    .resizable()
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .frame(width: 350, height: 250)
                    .scaledToFit()
                
                Button(action: {
                    vm.addFamily()
                    
                }, label: {
                    Text(LocalizedStringKey("Begin"))
                        .padding()
                        .frame(width: 200.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom, 70)
                
            }
            .onAppear {
                vm.getFamily()
            }
            .navigationDestination(for: Family.self) { famValue in
                StartMenuView()
            }
            .navigationDestination(for: Bool.self) { hasFamValue in
                AddFamilyView()
            }
            
        }.navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
