//
//  MemberRow.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-15.
//

import SwiftUI

struct MemberRow: View {
    
    @State var member = Member()
    @State var newMemberName = ""
    @State var addMode = false
    @State var isSelected = false
    
    
    
    var body: some View {
        
        HStack {
            if addMode == false {
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
           
            Image(systemName: "person")
                .font(.system(size: 36.0, weight: .bold))
            if addMode {
                Text(newMemberName)
                    .font(.title)
            }
            else {
                Text(member.name ?? "NO NAME")
                    .font(.title)
            }

            Spacer()
            
        }.padding(.leading)
        .padding(.top)
        .onTapGesture {
            if isSelected {
                isSelected = false
                member.isSelected = false
            }
            else {
                isSelected = true
                member.isSelected = false
            }
        }
    }
}

struct MemberRow_Previews: PreviewProvider {
    static var previews: some View {
        MemberRow()
    }
}
