//
//  FamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI


struct FamilyView: View {
    @ObservedObject var vm = FamilyViewViewModel()
    
    @State var noFam = false
    @State var goFam = false
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationLink(destination: AddFamilyView(), isActive: $goFam) {
                EmptyView()
            }.hidden()
            
            leaderView(leader: vm.familyMembers.first ?? Member())
            
            Divider().background(Color.blue)
                .alert("No family", isPresented: $noFam) {
                    Button("Add family") {
                        print("Adding family")
                        goFam = true
                    }
                }

            List {
                if vm.noFamily {
                    Text("No family memebers")
                }
                else {
                    ForEach(vm.familyMembers) { member in
                        TopListRow(member: member)
                    }
                }
            }.listStyle(.plain)
            
        }
        .onAppear(perform: {
            if vm.noFamily {
                print("NO FAMILY")
                noFam = true
            }
        })
        .navigationBarTitle("My family", displayMode: .automatic)
    }
}

struct leaderView: View {
    let leader: Member
        
    var body: some View {
        VStack(spacing: 10) {
            if leader.name == nil {
                Text("NO LEADER NAME!!!")
            }
            Text(leader.name ?? "No name")
                .font(.system(size: 35, weight: .semibold, design: .default))
            
            HStack(spacing: 4) {
                Text("\(leader.points ) p")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                
                Text("\(leader.time , specifier: "%.0f")  m")
                    .font(.system(size: 18, weight: .semibold, design: .default))

            }.padding(.trailing)
        }
    }
}

struct FamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FamilyView()
        }
    }
}
