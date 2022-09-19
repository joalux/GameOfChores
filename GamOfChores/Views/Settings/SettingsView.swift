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
    @State var goManageData = false
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
            
            NavigationLink(destination: ManageDataView(), isActive: self.$goManageData) {
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
                Text(LocalizedStringKey("ManageFamily"))
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
            
            Button(action: {
                print("Manage data!!")
                goManageData = true
            }, label: {
                Text(LocalizedStringKey("ManageData"))
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
                print(LocalizedStringKey("About"))
                showingAbout.toggle()
            }, label: {
                Text(LocalizedStringKey("About"))
                    .padding()
                    .frame(width: 220.0, height: 55.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }).padding(.bottom)
                .sheet(isPresented: $showingAbout){
                    AboutView()
                }
            
            Button(action: {
                print("Signing out")
                showSignOutAlert = true
                // SignOut()
            }, label: {
                Text(LocalizedStringKey("SignOut"))
                    .padding()
                    .frame(width: 190.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .cornerRadius(10)
            }).padding(.bottom)
            
        }.padding(.bottom, 20)
        
            .alert(isPresented: $showSignOutAlert, content: {
                
                Alert(title: Text(LocalizedStringKey("SignOut?")), message: Text(LocalizedStringKey("WantToSignOut")),primaryButton: .default(Text(LocalizedStringKey("No"))) {
                    print("No...")
                },secondaryButton: .destructive(Text(LocalizedStringKey("Yes"))) {
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
