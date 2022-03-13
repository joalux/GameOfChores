//
//  AddFamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI

struct AddFamilyView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var vm = AddNewFamilyViewModel()
    
    @State var memberName = ""
    
    @State var doSignUp = false
    @State var goSettings = false
    
    @State var fromSettings = false
    
    @FocusState private var showingKeyboard: Bool

    var body: some View {
        VStack(spacing: 10) {
            NavigationLink(destination: StartMenuView(), isActive: self.$doSignUp) {
               EmptyView()
             }.hidden()
            NavigationLink(destination: ManageFamilyView(), isActive: self.$goSettings) {
               EmptyView()
             }.hidden()
            
            Image("familyLogo")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
            if fromSettings {
                Text("Manage family members")
                    .font(.title)
            } else {
                Text("Add family members")
                    .font(.title)
            }
            
            Divider().background(Color.blue)

            List {
                Section("Members") {
                    ForEach(vm.famMembers, id: \.self){ member in
                        MemberRow(member: member, addMode: true)
                        
                    }
                }
               
            }.listStyle(.plain)
            
            Divider().background(Color.blue)
            
            TextField("Family member", text: $memberName)
                .padding(.leading, 40.0)
                .padding(.trailing, 40.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .focused($showingKeyboard)
                .disableAutocorrection(true)
            
            HStack {
               
                Button(action: {
                    print("Action")
                    vm.addFamMember(name: memberName)
                    memberName = ""
                    showingKeyboard = false
                    
                }, label: {
                    Text("Add")
                        .padding()
                        .frame(width: 150.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding()
                
                Button(action: {
                    vm.addFamMembers()
                    if fromSettings {
                        print("fam members added")

                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        print("signup complete")
                        doSignUp = true
                    }
                    
                }, label: {
                    Text("Done")
                        .padding()
                        .frame(width: 110.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding()
            }.onAppear {
                if fromSettings {
                    vm.getFamMembers()
                }
            }
        }
    }
}

struct AddFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        AddFamilyView()
    }
}
