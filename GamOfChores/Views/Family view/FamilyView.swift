//
//  FamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI


struct FamilyView: View {
    @StateObject var vm = FamilyViewViewModel()
    
    var body: some View {
      
        VStack(spacing: 10) {
            leaderView(leader: vm.familyMembers.first ?? Member())
            /*
            VStack(spacing: 10) {
                Text(vm.familyMembers.first?.name ?? "No name")
                    .font(.system(size: 35, weight: .semibold, design: .default))
                
                HStack(spacing: 4) {
                    Text("\(vm.familyMembers.first?.points ?? 0) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(vm.familyMembers.first?.time ?? 0, specifier: "%.0f")  m")
                        .font(.system(size: 18, weight: .semibold, design: .default))

                }.padding(.trailing)
            }*/
            
            Divider().background(Color.blue)

            List {
                ForEach(vm.familyMembers) { member in
                    TopListRow(member: member)
                }
            }.listStyle(.plain)
        }.navigationBarTitle("My family", displayMode: .automatic)
    }
}

struct leaderView: View {
    let leader: Member
        
    var body: some View {
        VStack(spacing: 10) {
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
