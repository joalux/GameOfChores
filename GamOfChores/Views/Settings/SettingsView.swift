//
//  SettingsView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-15.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var vm = SettingsViewModel()
    
    @State var showingFamSheet = false
    @State var showingDataSheet = false
    @State var showingConnectSheet = false
    
    @State var showingAbout = false
    
    @State var showSignOutAlert = false
    
    @State var goManageFam = false
    @State var goFirView = false
    
    @State var doSignOut = false
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: LoginView(), isActive: self.$doSignOut) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: ManageFamilyView(), isActive: self.$goManageFam) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: FirConnectView(inSettings: true), isActive: self.$goFirView) {
                EmptyView()
            }
            .hidden()
            
            Button(action: {
                print("Manage family")
                goManageFam = true
            }, label: {
                Text("Manage family")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
            
            Button(action: {
                showingDataSheet.toggle()
            }, label: {
                Text("Manage data")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .sheet(isPresented: $showingDataSheet) {
                    
                }
            
            Button(action: {
                
                print("Connect")
                goFirView = true
                
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
                print("About")
                showingAbout.toggle()
            }, label: {
                Text("About")
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .sheet(isPresented: $showingAbout){
                    
                }
            
            Button(action: {
                print("Signing out")
                showSignOutAlert = true
                // SignOut()
            }, label: {
                Text("Sign out")
                    .padding()
                    .frame(width: 190.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .cornerRadius(10)
            }).padding(.bottom)
            
        }.padding(.bottom, 20)
        
            .alert(isPresented: $showSignOutAlert, content: {
                
                Alert(title: Text("Sign out?"), message: Text("Do you want to sign out? If you are not connected, you will lose your family data saved on you device."),primaryButton: .default(Text("no")) {
                    print("No...")
                },secondaryButton: .destructive(Text("yes")) {
                    print("Deleting...")
                    vm.signOut()
                    doSignOut = true
                }
                )
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
