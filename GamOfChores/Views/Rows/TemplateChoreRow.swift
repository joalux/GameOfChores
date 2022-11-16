//
//  templateChoreRow.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-08-30.
//

import SwiftUI

struct TemplateChoreRow: View {
    @StateObject var chore: Chore

    var body: some View {
        HStack {
            if chore.isCustom {
                Image("choreAlert")
                    .resizable()
                    .frame(width: 55, height: 55, alignment: .center)
            }
            else {
                Image(chore.type ?? "")
                    .resizable()
                    .frame(width: 55, height: 55, alignment: .center)
            }
           
            VStack(alignment: .leading) {
                Text(chore.type ?? "CHORE??")
                    .font(.system(size: 22, weight: .semibold, design: .default))
             
            }
           
            Spacer()
        
            VStack {
                Text(" \(chore.value) p")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    .padding(.bottom, 5)
                if chore.hasTimeLimit {
                    Text(" \(chore.timeLimit, specifier: "%.0f") m")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                }
            }
                
            }.frame(height: 60)
        }
}

