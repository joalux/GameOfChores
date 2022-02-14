//
//  MemberView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-12.
//

import SwiftUI

struct MemberView: View {
    
    @ObservedObject var vm = MemberViewViewModel()
    
    @StateObject var selectedMember = Member()
    
    var body: some View {
        VStack {
            VStack {
                Text(selectedMember.name ?? "No name")
                    .font(.system(size: 35, weight: .semibold, design: .default))
                
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
