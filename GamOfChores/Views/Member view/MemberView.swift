//
//  MemberView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-12.
//

import SwiftUI

struct MemberView: View {
        
    var selectedMember: Member
    
    @ObservedObject var vm = MemberViewViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 15) {
                Text(selectedMember.name ?? "No name")
                    .underline()
                    .font(.system(size: 35, weight: .semibold, design: .default))
                
                HStack(spacing: 4) {
                    Text("\(selectedMember.points) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(selectedMember.time, specifier: "%.0f") m")
                        .font(.system(size: 18, weight: .semibold, design: .default))

                }.padding(.trailing)

            }.padding(.bottom)
            .navigationBarTitle("", displayMode: .inline)

            
            Divider().background(Color.blue)

            List {
                ForEach(vm.memberChores) { chore in
                    CompleteChoreRow(chore: chore)
                }
            }.listStyle(.plain)
        }.onAppear {
            print("______--MEMBER VIEW: \(selectedMember.name)_____")
            vm.selectedMember = selectedMember
            vm.getCompleted()
        }
    }
}

