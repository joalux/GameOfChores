//
//  AddFamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI

struct AddFamilyView: View {
    
    @StateObject private var vm = AddNewFamilyViewModel()
    
    @State var memberName = ""
    
    @State var doSignUp = false
    
    @FocusState private var showingKeyboard: Bool

    var body: some View {
        VStack {
            NavigationLink(destination: StartMenuView(), isActive: self.$doSignUp) {
               EmptyView()
             }.hidden()
            Image("familyLogo")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
            Text("Add family members")
                .font(.title)
            Divider().background(Color.blue)

            List {
                ForEach(vm.memberNames, id: \.self){ name in
                    MemberRow(newMemberName: name, addMode: true)
                    
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
                    vm.memberNames.append(memberName)
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
                    print("signup complete")
                    vm.addFamMembers()
                    doSignUp = true
                   
                    
                }, label: {
                    Text("Done")
                        .padding()
                        .frame(width: 110.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding()
            }
        }
    }
}

struct AddFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        AddFamilyView()
    }
}
