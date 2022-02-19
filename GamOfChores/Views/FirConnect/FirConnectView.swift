//
//  FirConnectView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-09.
//

import SwiftUI

struct FirConnectView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var vm = FirConnectViewModel()
    
    var body: some View {
        VStack {
           /*
            NavigationLink(destination: StartMenuView(), isActive: self.$doConnect) {
                StartMenuView()
            }.hidden()
            .frame(height: 0)
            
            NavigationLink(destination: AddNewFamilyView(), isActive: self.$doRegister) {
                EmptyView()
            }.hidden() */
            
            Spacer()
            
            
            Image("theCloud")
                .resizable()
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .frame(width: 220, height: 150)
                .scaledToFill()
                .padding(.bottom)
                .padding(.top)
                .alert(isPresented: $vm.firError){
                    Alert(title: Text("Error!"), message: Text("\( vm.resultString)"), dismissButton: .default(Text("Close")){
                        print("Dismissing")
                        vm.firLoading = false
                        
                    })
            }
            
            if vm.firLoading {
                ProgressView()
                    .frame(width: 100, height: 100, alignment: .center)
                    .scaleEffect(2)
                    .alert(isPresented: $vm.firSuccess) { Alert(title: Text("Success!"), message: Text("You are now connected!"), dismissButton: .default(Text("Close")){
                        print("__Closing___")
                        if vm.connectFam {
                            vm.doRegister = true
                        }
                        else {
                            vm.doConnect = true
                        }
                        vm.firLoading = false
                        
                        })

                    }
            }
            
            else if vm.firFamily.isConneted == true {
               
                    Button(action: {
                        print("Action")
                        
                        vm.doConnect = true
                        print(vm.firFamily.id)
                     
                    }, label: {
                        Text("Continuue")
                            .padding()
                            .frame(width: 180.0, height: 45.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    })
                }
                else {
                    Button(action: {
                        print("Action")
                        vm.showDisconnectDevAlert = true
                        print(vm.firFamily.id)
                     
                    }, label: {
                        Text("Disconnect device")
                            .padding()
                            .frame(width: 180.0, height: 45.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    }).alert(isPresented: $vm.showDisconnectDevAlert) { Alert(title: Text("Disconnect?"), message: Text("Do you want to disconnect your device from your family?"), primaryButton: .destructive(Text("Disconnect")) {
                        print("Disconnecting...")
                        vm.disconnectFamily()
                    },
                    secondaryButton: .cancel()
                    )}
                    Button(action: {
                        print(vm.firFamily.id)
                   
                        vm.showDisconnectFamAlert = true
                     
                    }, label: {
                        Text("Disconnect family")
                            .padding()
                            .frame(width: 180.0, height: 45.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    }).alert(isPresented: $vm.showDisconnectFamAlert) {  Alert(title: Text("Disconnect?"), message: Text("Do you want to disconnect your family?"), primaryButton:                     .destructive(Text("Disconnect")) {
                                print("Disconnecting...")
                                vm.disconnectFamily()
                        
                            },secondaryButton: .cancel()
                        )}
                }
                    
               
            }
            
        
                VStack {
                    
                    TextField("Family mail", text: $vm.famMail)
                        .padding(.leading, 75.0)
                        .padding(.trailing, 75.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                       
                        
                    SecureField("Password", text: $vm.famPass)
                        .padding(.leading, 75.0)
                        .padding(.trailing, 75.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                      
                    if vm.doRegister {
                        SecureField("repeat Password", text: $vm.famPass2)
                            .padding(.leading, 75.0)
                            .padding(.trailing, 75.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                    }
                        
                    }.padding(.bottom)
                    .background(Color.white)
                    .alert(isPresented: $vm.firSuccess) { Alert(title: Text("Success!"), message: Text("You are now connected!"), dismissButton: .default(Text("Close")){
                        print("__Closing___")
                        vm.firLoading = false
                        vm.doConnect = true
                       
                        
                        })

                    }
            
          
            
            if vm.firLoading == false {
                if vm.firFamily.isConneted == false {
                    
                
                    HStack {
                        Button(action: {
                            print("Action")
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
                            Text("Create")
                                .padding()
                                .frame(width: 100.0, height: 40.0)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .cornerRadius(10)
                        }) .alert(isPresented: $vm.showAlert) {
                            Alert(title: Text(""), message: Text("\( vm.resultString)").font(.title), dismissButton: .default(Text("Close")){
                                print("Dismissing")
                                if vm.firSuccess == true {
                                    print("signuo success!!!!")
                                    vm.doConnect = true
                                }
                            }
                        )
                    }
            }
                
                    Button(action: {
                        print("Action")
                        vm.connectFamily()
                        
                    }, label: {
                        Text("Connect")
                            .padding()
                            .frame(width: 180.0, height: 45.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    })
                    
                    
                }
            }
            Spacer()
          
                
                Button(action: {
                    print("Done")
                    self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Close")
                        .padding()
                        .frame(width: 190.0, height: 40.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.top)
            
    }
}

struct FirConnectView_Previews: PreviewProvider {
    static var previews: some View {
        FirConnectView()
    }
}
