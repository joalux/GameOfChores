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
            
            HStack {
                Text(vm.familyMembers.first?.name ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                VStack(spacing: 4) {
                    Text("\(vm.familyMembers.first?.points ?? 0) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(vm.familyMembers.first?.time ?? 0, specifier: "%.0f") m")
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

struct FamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FamilyView()
        }
    }
}
