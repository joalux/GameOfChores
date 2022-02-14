//
//  FamilyView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import SwiftUI


struct FamilyView: View {
    @ObservedObject var vm = FamilyViewViewModel()
    
    var body: some View {
      
        VStack {
            VStack {
                Text(vm.familyMembers.first?.name ?? "No name")
                    .font(.system(size: 35, weight: .semibold, design: .default))
                
                HStack(spacing: 4) {
                    Text("\(vm.familyMembers.first?.points ?? 0) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(vm.familyMembers.first?.time ?? 0, specifier: "%.0f")  m")
                        .font(.system(size: 18, weight: .semibold, design: .default))

                }.padding(.trailing)
            }
            
            Divider().background(Color.blue)

            List {
                ForEach(vm.familyMembers) { member in
                    TopListRow(member: member)
                }
            }.listStyle(.plain)
        }.navigationBarTitle("My family", displayMode: .automatic)
        .onAppear(perform: vm.getFamily)
    }
}

struct leaderView: View {
    let leader: Member
    
    var leaderName = ""
    
    var body: some View {
        HStack {
            Text("No name")
                .font(.title)
                .fontWeight(.bold)
            VStack(spacing: 4) {
                Text("oints) p")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                
                Text("time  m")
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
