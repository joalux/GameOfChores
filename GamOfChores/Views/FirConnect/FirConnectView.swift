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
    @ObservedObject private var vm = FirConnectViewModel()
    @StateObject private var keyboardManager = KeyboardManager()
    
    @State var doConnect = false
    @State var doRegister = false
    
    @State var inSettings = false
    @State var goSettings = false
    
    @State private var showingAlert = false
    
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
                .alert(isPresented: $vm.firSuccess) {
                    
                   Alert(title: Text("Success!"), message: Text("You are now connected!"), dismissButton: .default(Text("Continue")){
                       print("HAS LOGGED IN!!")
                       if vm.createFam {
                           navManager.goToAddFamily()
                       }
                       else {
                           navManager.goToStart()
                       }
                       
                   })
               }
            
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
                
                if vm.createFam == true {
                    
                    SecureField(LocalizedStringKey("FamPassRepeat"), text: $vm.famPass2)
                        .padding(.leading, 60.0)
                        .padding(.trailing, 60.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)

                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                
            }.padding(.bottom)
            
            HStack {
                Button(action: {
                    withAnimation {
                        vm.createFam = false
                    }
                    
                }, label: {
                    Text("Join")
                        .padding()
                        .frame(width: 100.0, height: 40.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).alert(isPresented: $vm.showJoinAlert) {  Alert(title: Text("Join family?"), message: Text(LocalizedStringKey("ConnectFam")), primaryButton: .default(Text("Join")) {
                    print("joining family...")
                    vm.connect()
                    
                },secondaryButton: .cancel()
                )}
                
                Button(action: {
                    print("Create")
                    
                    withAnimation {
                        vm.createFam = true
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
            }
            
            Button("Connect") {
                vm.connectFamily()
            }
            .padding()
            .frame(width: 180.0, height: 45.0)
            .background(vm.famMail.isEmpty ? .gray : .blue)
            .foregroundColor(.white)
            .disabled(vm.famMail.isEmpty)
            .font(.subheadline)
            .cornerRadius(10)
            .alert(isPresented: $vm.firError) {
                Alert(title: Text("Error"), message: Text(vm.resultString), dismissButton: .default(Text("Close!")))
            }
        }
       
        /*
            VStack {
                
                Image(systemName: "cloud")
                    .resizable()
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .frame(width: 200, height: 130)
                    .scaledToFill()
                    .padding(.bottom)
                    .font(Font.body.weight(.thin))
                    .foregroundColor(.blue)
                    .alert(isPresented: $vm.firError){
                        Alert(title: Text(LocalizedStringKey("BadPass") ), message: Text("\( vm.resultString)"), dismissButton: .default(Text(LocalizedStringKey("Close"))){
                            vm.firLoading = false
                            
                        })
                    }
                
                if vm.firLoading {
                    ProgressView()
                        .frame(width: 100, height: 100, alignment: .center)
                        .scaleEffect(2)
                        .alert(isPresented: $vm.firSuccess) { Alert(title: Text(LocalizedStringKey("isConnected")), message: Text(LocalizedStringKey("Vonnected")), dismissButton: .default(Text(LocalizedStringKey("Close"))){
                        vm.firLoading = false
                       
                        
                        if inSettings {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        else {
                            if vm.createFam {
                                vm.doRegister = true
                            } else {
                                vm.doConnect = true
                            }
                            
                        }
                        
                    })
                }
                     
                }
                
                if vm.firLoading == false {
                    
                    if vm.coreFamily.isConnected {
                     
                        Button(action: {
                            print("Action")
                            vm.showDisconnectDevAlert = true
                            print(vm.coreFamily.id)
                            
                        }, label: {
                            Text("Disconnect")
                                .padding()
                                .frame(width: 180.0, height: 45.0)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .cornerRadius(10)
                        }).alert(isPresented: $vm.showDisconnectDevAlert) { Alert(title: Text("Disconnect?"), message: Text(LocalizedStringKey("DisconnectDevice")), primaryButton: .destructive(Text("Disconnect")) {
                            print("Disconnecting...")
                            vm.disconnectDevice()
                            
                        },secondaryButton: .cancel()
                        )}
                        
                        Button(action: {
                            print(vm.coreFamily.id)
                            
                            vm.showDisconnectFamAlert = true
                            
                        }, label: {
                            Text("Disconnect family")
                                .padding()
                                .frame(width: 180.0, height: 45.0)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .cornerRadius(10)
                        }).alert(isPresented: $vm.showDisconnectFamAlert) {  Alert(title: Text("Disconnect?"), message: Text(LocalizedStringKey("DisconnectFam")), primaryButton:                     .destructive(Text("Disconnect")) {
                            print("Disconnecting...")
                            vm.disconnectFamily()
                            
                        },secondaryButton: .cancel()
                        )}
                    }
                    else {
                        
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
                            
                            if vm.createFam == true {
                                
                                SecureField(LocalizedStringKey("FamPassRepeat"), text: $vm.famPass2)
                                    .padding(.leading, 60.0)
                                    .padding(.trailing, 60.0)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)

                                    .ignoresSafeArea(.keyboard, edges: .bottom)
                            }
                            
                        }.padding(.bottom)
                       // .background(Color.white)
                    }

                    if vm.coreFamily.isConnected == false {
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    vm.createFam = false
                                }
                                
                            }, label: {
                                Text("Join")
                                    .padding()
                                    .frame(width: 100.0, height: 40.0)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .cornerRadius(10)
                            }).alert(isPresented: $vm.showJoinAlert) {  Alert(title: Text("Join family?"), message: Text(LocalizedStringKey("ConnectFam")), primaryButton:                     .default(Text("Join")) {
                                print("joining family...")
                                vm.connect(create: false)
                                
                            },secondaryButton: .cancel()
                            )}
                            
                            Button(action: {
                                print("Create")
                                
                                withAnimation {
                                    vm.createFam = true
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
                            .alert(isPresented: $vm.showInvalidPassAlert) {  Alert(title: Text("Error!"), message: Text(LocalizedStringKey("InvalidPass")), dismissButton:.default(Text(LocalizedStringKey("Close"))) {
                                
                            }
                            )}
                            
                        }
                        
                        Button(action: {
                            vm.connect2()
                            vm.firSuccess = true
                            vm.firError = true
                            vm.showDisconnectDevAlert = true
                            print(vm.firSuccess)
                            /*
                            if vm.createFam {
                                if vm.famPass == vm.famPass2 {
                                    if vm.famPass.count >= 6 {
                                        vm.connect(create: true, members: CoreDataManager.shared.getFamilyMembers(), chores: CoreDataManager.shared.getChores())
                                    }
                                    else {
                                        vm.showShortPassAlert = true
                                    }
                                }
                                else {
                                    vm.showInvalidPassAlert = true
                                }
                            }
                            else {
                                vm.connect(create: vm.createFam)
                            }*/
                            
                        }, label: {
                            Text("Connect")
                                .padding()
                                .frame(width: 180.0, height: 45.0)
                                .background(vm.famMail.isEmpty ? .gray : .blue)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .cornerRadius(10)
                        })
                        .alert(isPresented: $vm.firSuccess) {
                            Alert(
                              title: Text(LocalizedStringKey("isConnected")),
                              message: Text(LocalizedStringKey("Connected")),
                              dismissButton: .default(Text(LocalizedStringKey("Continue"))) {
                                  print("Signup complete...")
                                  if vm.createFam {
                                      doRegister = true
                                  }
                                  else {
                                      doConnect = true
                                  }
                              }
                          )
                        }
                    }
                }
         
            }.padding(.bottom, keyboardManager.keyboardHeight + 140)
            .alert(isPresented: $vm.showShortPassAlert) {  Alert(title: Text("Error!"), message: Text(LocalizedStringKey("BadPass")), dismissButton:.default(Text(LocalizedStringKey("Close"))) {
                
            }
            )}*/
           
    }
    
}

struct FirConnectView_Previews: PreviewProvider {
    static var previews: some View {
        FirConnectView()
    }
}
