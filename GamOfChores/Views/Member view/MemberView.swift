//
//  MemberView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-12.
//

import SwiftUI

struct MemberView: View {
    
    @StateObject var vm = MemberViewViewModel()
    
    @StateObject var selectedMember = Member()
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 15) {
                Text(selectedMember.name ?? "No name")
                    .underline()
                    .font(.system(size: 35, weight: .semibold, design: .default))
                Text("\(selectedMember.choreCount) chores completed")
                HStack(spacing: 4) {
                    Text("\(selectedMember.points ?? 0) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(selectedMember.time ?? 0, specifier: "%.0f")  m")
                        .font(.system(size: 18, weight: .semibold, design: .default))

                }.padding(.trailing)
            }
            
            Divider().background(Color.blue)

            List {
                ForEach(vm.completedChores) { chore in
                    CompleteChoreRow(chore: chore)
                }
            }.listStyle(.plain)
        }.onAppear {
            vm.selectedMember = selectedMember
            vm.getCompleted()
        }
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
    }
}
