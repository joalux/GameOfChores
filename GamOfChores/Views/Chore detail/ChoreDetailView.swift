//
//  ChoreDetailView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-15.
//

import SwiftUI

struct multiMemberSelectionRow: View {
    
    var member: Member
    
    @Binding var selectedMembers: Set<Member>
    
    var isSelected: Bool {
        selectedMembers.contains(member)
    }
    
    var body: some View {
        HStack() {
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
            
            Text(self.member.name ?? "no name")
                .font(.title)
                .fontWeight(.bold)
                
            
           
            Spacer()
        }

        .onTapGesture {
            if self.isSelected {
                self.selectedMembers.remove(self.member)
            } else {
                self.selectedMembers.insert(self.member)
            }
        }
    }
}

struct ChoreDetailView: View {
    
    @StateObject var vm = ChoreDetailViewModel()
    
    @ObservedObject var firHelper = FireBaseHelper()
    
    @Environment(\.presentationMode) var presentationMode
    
    var selectedChore = Chore()
    
    @State var showComplete = false
    
    @State var selectedMembers = Set<Member>()
   
    var body: some View {
        VStack {
                
            Text("\(selectedChore.type!) \(selectedChore.value)p")
                .font(.system(size: 35, weight: .medium, design: .default))
            
            if selectedChore.isCustom {
                Image("choreAlert")
                    .resizable().padding()
                    .frame(width: 140, height: 140, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
            }
            else {
                Image(selectedChore.type ?? "")
                    .resizable().padding()
                    .frame(width: 140, height: 140, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
            }
            if vm.hasStarted == false {
                Text("\(selectedChore.timeLimit, specifier: "%.0f") m \(vm.seconds) s")
                    .font(.system(size: 25, weight: .medium, design: .default))
            }
            else {
                
                if selectedChore.hasTimeLimit {
                    Text(" \(vm.minutes) m \(vm.seconds) s")
                        .font(.system(size: 25, weight: .medium, design: .default))
                }
                else {
                    Text(" \(vm.minutes) m \(vm.seconds) s")
                        .font(.system(size: 25, weight: .medium, design: .default))

                }
            }
            
            Divider().background(Color.blue)
            Text("tap to select participants")
            
            List(vm.familyMembers, selection: $selectedMembers) { member in
                multiMemberSelectionRow(member: member, selectedMembers: $selectedMembers)
            }.listStyle(.plain)
            .frame(width: 250)
            .listStyle(.plain)
            .padding(.horizontal)
          
            Divider().background(Color.blue)

            HStack {
                Button(action: {
                    
                    vm.setTimer(reset: false)
             
                }) {
                    Text(vm.buttonText)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 5)
                        .fill(selectedMembers.isEmpty ? Color(UIColor.lightGray) : Color.blue))
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(15)
                }.disabled(selectedMembers.isEmpty)
                .onDisappear {
                    print("_____DISAPPEAR!!!")
                    vm.restartTimer()
                }
                
                Button(action: {
                    vm.setTimer(reset: true)
                    
                }) {
                    Text("Reset")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background( Color.blue)
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(15)
                }
                .alert(isPresented: $vm.hasEnded, content: {
                    Alert(title: Text("Time is up!"), message: Text("You will not get any extra points for this chore."), dismissButton: .default(Text("Ok")){
                       
                        self.presentationMode.wrappedValue.dismiss()

                    })
                })
                .alert(isPresented: $showComplete, content: {
                    Alert(title: Text("Chore is done!"), message: Text("You will get \(selectedChore.value) points + \(vm.timeSpent) extra points and \(vm.timeSpent) minutes for this chore."), dismissButton: .default(Text("Ok")){
                        
                        self.presentationMode.wrappedValue.dismiss()
                       
                    })
                })
                
            }
                Button(action: {
                    print("Completing chore!!")
                    
                    vm.pauseTimer()
                    for selectedMember in selectedMembers {
                        print(selectedMember.name)
                    }
                    
                    vm.completeChore(selectedMembers: selectedMembers)

                    showComplete = true
                    
                }, label: {
                    Text("Complete Chore")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding()
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 5)
                            .fill(selectedMembers.isEmpty ? Color(UIColor.lightGray) : Color.blue)
                        )
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(15)
                })
                .disabled(selectedMembers.isEmpty)
            
        }.onAppear {
            print("APPEAR!!!")
            vm.selectedChore = selectedChore
                      
        }
    }
}

struct ChoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreDetailView()
    }
}

