//
//  MnageDatView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-04-23.
//

import SwiftUI

struct ManageDataView: View {
    
    @State var showManageFamily = false
    @State var showManageChores = false
    
    @StateObject var vm = SettingsViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
           
            
            NavigationLink(destination: AddFamilyView(fromSettings: true), isActive: self.$vm.manageFamily) {
                EmptyView()
            }.hidden()
            
            Button(action: {
                vm.showResetTodoAlert = true
            }, label: {
                Text("Reset to do")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .alert(isPresented:$vm.showResetTodoAlert) {
                    Alert(
                        title: Text("Reset?"),
                        message: Text("Do you want to reset? All chores will be removed."),
                        primaryButton: .destructive(Text("Yes"), action: {
                            print("Resetting!!!")
                            vm.resetChores(resetTodo: true)
                            
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            print("no reset!!")
                        })
                    )
                }
            
            
            Button(action: {
                vm.showResetCompletedAlert = true
            }, label: {
                Text("Reset completed")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .alert(isPresented:$vm.showResetCompletedAlert) {
                    Alert(
                        title: Text("Reset?"),
                        message: Text("Do you want to reset? All completed chores will be removed."),
                        primaryButton: .destructive(Text("Yes"), action: {
                            print("Resetting!!!")
                            vm.resetChores(resetTodo: false)
                            
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            print("no reset!!")
                        })
                    )
                }
        }
    }
}

struct MnageDatView_Previews: PreviewProvider {
    static var previews: some View {
        ManageDataView()
    }
}
