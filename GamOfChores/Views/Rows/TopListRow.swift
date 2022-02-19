//
//  TopListRow.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-22.
//

import SwiftUI

struct TopListRow: View {
    
    @State var member = Member()
    
    var body: some View {
        NavigationLink(destination: MemberView(selectedMember: member)) {
            
            HStack {
                
                Image(systemName: "person")
                    .font(.system(size: 36.0, weight: .bold))
                
                Text(member.name ?? "no name")
                    .font(.title)
                
                Spacer()
                
                
                VStack(spacing: 4) {
                    Text("\(member.points) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text("\(member.time, specifier: "%.0f") m")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                }.padding(.trailing)
            }
            
        }.padding(.leading)
            .padding(.top)
    }
}

struct TopListRow_Previews: PreviewProvider {
    static var previews: some View {
        TopListRow()
    }
}
