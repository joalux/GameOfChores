//
//  FamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI


struct FamilyView: View {
    @ObservedObject var vm = FamilyViewViewModel()
    @EnvironmentObject var navManager: NavigationManager

    @State var noFam = false
    @State var goFam = false
    
    var body: some View {
        
        VStack() {
            if vm.hasFamily  {
                Text("Leader")
                leaderView(leader: vm.leader)
            }
                  
            Divider().background(.blue)
          
            List {
                if vm.noFamily || vm.familyMembers.isEmpty{
                    Text("No family memebers")
                }
                else {
                    ForEach(vm.familyMembers) { member in
                        if let name = member.name {
                            TopListRow(member: member)
                        }
                        else {
                            Text("No nsme")
                        }
                    }
                }
            }.listStyle(.plain)
            .refreshable {
                vm.fetchFamily()
            }
            
            if vm.noFamily {
                Button("Add family") {
                    print("Adding family")
                    navManager.goToAddFamily()
                    
                }
            }
           
            
            Spacer()
        }
        .navigationBarTitle(LocalizedStringKey("MyFamily"))
        .onAppear(perform: {
            print("APPEAR!!!!")
            vm.fetchFamily()
            
            print("FAM FETCHED!!")
            
            if vm.noFamily {
                print("NO FAMILY")
            }
            print("FAMCOUNT = \(vm.familyMembers.count)")
            
        })
    }
}

struct leaderView: View {
    let leader: Member
        
    var body: some View {
        VStack() {
            Text(leader.name ?? "No name")
                .font(.system(size: 35, weight: .semibold, design: .default))
            
            HStack(spacing: 4) {
                Text("\(leader.points ) p")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                
                Text("\(leader.time , specifier: "%.0f") m")
                    .font(.system(size: 18, weight: .semibold, design: .default))

            }.padding(.trailing)
        }
        .onAppear {
            print("_____LEADER VIEW_______")
            if leader.name == nil {
                leader.name = "No name"
            }
        }
            
    }
}

