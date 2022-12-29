//
//  FirConnectView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import SwiftUI

struct FirConnectView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var vm = FirConnectViewModel()
    @StateObject private var keyboardManager = KeyboardManager()
    
    @State var doConnect = false
    @State var doRegister = false
    
    @State var inSettings = false
    @State var goSettings = false
    
    var body: some View {
        VStack {
            
            Image(systemName: "cloud")
                .resizable()
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .frame(width: 200, height: 130)
                .scaledToFill()
                .padding(.bottom)
                .font(Font.body.weight(.thin))
                .foregroundColor(.accentColor)
                
            
            VStack {
                
                TextField(LocalizedStringKey("FamilyMail"), text: $vm.famMail)
                    .textInputAutocapitalization(.never)
                    .padding(.leading, 60.0)
                    .padding(.trailing, 60.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
                SecureField(LocalizedStringKey("FamPass"), text: $vm.famPass)
                    .padding(.leading, 60.0)
                    .padding(.trailing, 60.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
                if vm.connectFam == true {
                    
                    SecureField(LocalizedStringKey("FamPassRepeat"), text: $vm.famPass2)
                        .padding(.leading, 60.0)
                        .padding(.trailing, 60.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .alert(isPresented: $vm.showMismatchPassAlert) {
                            Alert(title: Text("Error"), message: Text("Your passwords does not match!"), dismissButton: .default(Text("Close!")))
                        }
                }
                
            }.padding(.bottom)
            
            HStack {
                Button(action: {
                    withAnimation {
                        vm.connectFam = false
                    }
                    
                }, label: {
                    Text("Join")
                        .padding()
                        .frame(width: 100.0, height: 40.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                })
                
                Button(action: {
                    print("Create")
                    
                    withAnimation {
                        vm.connectFam = true
                    }
                    
                }, label: {
                    Text(LocalizedStringKey("Create"))
                        .padding()
                        .frame(width: 100.0, height: 40.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                })
                .alert(isPresented: $vm.firError) {
                    
                    Alert(title: Text("Error!"), message: Text(vm.resultString), dismissButton: .default(Text("Close")){
                        print("closing!!")
                        vm.firError = false
                        
                        
                    })
                }
            }
            
            Button("Connect") {
                if vm.connectFam {
                    vm.connectFamily()
                }
                else {
                    vm.joinFamily()
                }
            }
            .padding()
            .frame(width: 180.0, height: 45.0)
            .background(vm.famMail.isEmpty ? .gray : .blue)
            .foregroundColor(.white)
            .disabled(vm.famMail.isEmpty)
            .font(.subheadline)
            .cornerRadius(10)
            .alert(isPresented: $vm.firSuccess) {
                
                Alert(title: Text("Success!"), message: Text(vm.resultString), dismissButton: .default(Text("Continue")){
                    print("closing!!")
                    navManager.goToAddFamily()
                    
                })
            }
           
        }
           
    }
    
}

struct FirConnectView_Previews: PreviewProvider {
    static var previews: some View {
        FirConnectView()
    }
}
