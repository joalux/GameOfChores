//
//  AddFamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI

struct AddFamilyView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var navManager: NavigationManager

    @StateObject private var vm = AddFamilyViewModel()
    @StateObject var firHelper = FireBaseHelper()
    
    @State var memberName = ""
    
    @State var doSignUp = false
    @State var doConnect = false
    @State var goSettings = false
    
    @State var fromSettings = false
    @State var fromFamilyView = false
    
    @FocusState private var showingKeyboard: Bool

    var body: some View {
        VStack(spacing: 0) {
                    
            Image("familyLogo")
                .resizable()
                .frame(width: 110, height: 110)
                .scaledToFill()
            if fromSettings {
                Text("Manage family members")
                    .font(.title3)
                    .padding()
            } else {
                Text("Add family members: \(vm.famMembers.count)")
                    .font(.title3)
                    .padding()
            }
            Divider().background(Color.blue)

            List {
                ForEach(vm.memberNames, id: \.self){ name in
                    MemberRow(newMemberName: name, addMode: true)
                }.onDelete(perform: removeFamMember)
            }.listStyle(.plain)
                .alert("Success!", isPresented: $firHelper.firSuccess, actions: {
                      Button("Continue") {
                          navManager.goToStart()
                      }
                    }, message: {
                      Text("Your family has been added.")
                    })
            
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
                        
                        vm.memberNames.append(memberName)
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
                    print("ADDING FAMILY!!!")
                    
                    vm.addFamily()
                    print(vm.famMembers.count)
                    if vm.coreFamily.isConnected {
                        firHelper.addFirMembers(firID: vm.coreFamily.firID!, famMembers: vm.famMembers)
                    }
                    else {
                        if fromSettings {
                            print("fam members added")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        else if fromFamilyView {
                            print("fam members added")
                            navManager.goToFamily()
                        }
                        else {
                            print("signup complete")
                            navManager.goToStart()
                        }
                    }
                                        
                }, label: {
                    Text("Done")
                        .padding()
                        .frame(width: 110.0, height: 45.0)
                        .background(vm.memberNames.isEmpty ? .gray : .blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.trailing)
                    //.disabled(vm.memberNames.isEmpty)
                    .alert(isPresented:$firHelper.firError) {
                      Alert(
                          title: Text("Error!"),
                          message: Text(firHelper.firErrorString),
                          dismissButton: .default(Text("Close"), action: {
                              print("Closing!!!")
                              
                          })
                      )
                  }
               
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
            FireBaseHelper.shared.removeMemAtOffsets(at: offsets)
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


