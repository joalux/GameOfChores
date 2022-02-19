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
        NavigationView {
            
            VStack(spacing: 0) {
                
                Button(action: {
                    showManageFamily = true
                }, label: {
                   Text("Reset")
                       .padding()
                       .frame(width: 220.0, height: 55.0)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .font(.headline)
                       .cornerRadius(10)
               }).padding(.bottom)
                .alert(isPresented:$vm.showConnectAlert) {
                    Alert(
                        title: Text("Do you want to connect?"),
                        message: Text("You can connect to an existing family or create a new for your family to connct to."),
                        primaryButton: .default(Text("Yes"), action: {
                            print("Connecting!!!")
                            vm.connectFamily()
                            
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            print("no connect!!")                            
                        })
                    )
                }
                   
               Button(action: {
                    
               }, label: {
                    Text("Connect")
                       .padding()
                       .frame(width: 220.0, height: 55.0)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .font(.headline)
                       .cornerRadius(10)
               }).padding(.bottom)
               

                   
                Button(action: {

                }, label: {
                    Text("Close")
                        .padding()
                        .frame(width: 190.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom)
            }
        }.navigationBarHidden(true)
    }
}

struct ManageFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFamilyView()
    }
}
