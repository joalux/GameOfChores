//
//  AddFamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI

struct AddFamilyView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var vm = AddFamilyViewModel()
    @ObservedObject var firHelper = FireBaseHelper()
    
    @State var memberName = ""
    
    @State var doSignUp = false
    @State var doConnect = false
    @State var goSettings = false
    
    @State var fromSettings = false
    
    @FocusState private var showingKeyboard: Bool

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: StartMenuView(), isActive: self.$doSignUp) {
               EmptyView()
             }.hidden()
            NavigationLink(destination: ManageFamilyView(), isActive: self.$goSettings) {
               EmptyView()
             }.hidden()
        
            
            Image("familyLogo")
                .resizable()
                .frame(width: 110, height: 110)
                .scaledToFill()
            if fromSettings {
                Text("Manage family members")
                    .font(.title3)
                    .padding()
            } else {
                Text("Add family members")
                    .font(.title3)
                    .padding()
            }
            Divider().background(Color.blue)

            List {
                if vm.coreFamily.isConnected {
                    ForEach(firHelper.firMembers, id: \.self){ member in
                        MemberRow(member: member, addMode: true)
                    }.onDelete(perform: firHelper.removeMemAtOffsets)
                }
                else {
                    ForEach(vm.famMembers, id: \.self){ member in
                        MemberRow(member: member, addMode: true)
                    }.onDelete(perform: removeFamMember)

                }
            
            }.listStyle(.plain)
            
            Divider().background(Color.blue)

            TextField("Family member", text: $memberName)
                .autocapitalization(.none)
                .padding(.top)
                .padding(.leading, 40.0)
                .padding(.trailing, 40.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($showingKeyboard)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            
            
            HStack {
               
                Button(action: {
                    if memberName.isEmpty {
                        vm.showNoNameAlert = true
                    } else {
                        if vm.coreFamily.isConnected {
                            print("Adding firmember!!!")
                            if let firID = vm.coreFamily.firID {
                                firHelper.addNewFirMember(firID: firID, memberID: UUID().uuidString, firName: memberName)
                            }
                            else {
                                print("NO ID!!!")
                            }
                        }
                        else {
                            
                            vm.addFamMember(name: memberName, firID: "")
                        }
                        memberName = ""
                    }
                    showingKeyboard = false
                    
                }, label: {
                    Text("Add")
                        .padding()
                        .frame(width: 150.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.leading)
                  .alert(isPresented:$vm.showNoNameAlert) {
                    Alert(
                        title: Text("Error!"),
                        message: Text("You have to have a name for your new family member!"),
                        dismissButton: .default(Text("Close"), action: {
                            print("Closing!!!")
                            
                        })
                    )
                }
                Button(action: {
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
                }).padding(.trailing)
               
            }
            .padding(.top)
            .onAppear {
                if vm.coreFamily.isConnected {
                    firHelper.getFirMembers(firID: vm.coreFamily.firID ?? "")
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeFamMember(at offsets: IndexSet) {
        if vm.coreFamily.isConnected {
            
            firHelper.firMembers
            firHelper.removeMemAtOffsets(at: offsets)
        }
        else {
            vm.removeMember(at: offsets)
        }
    }
}

struct AddFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        AddFamilyView()
    }
}
