//
//  CompleteChoreRow.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-02-15.
//

import SwiftUI

struct CompleteChoreRow: View {
    
    @StateObject var chore: Chore
    
    let formatter = DateFormatter()
    @State var dateCompleString = ""
    
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
                Text(chore.type ?? "")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                
            }
            
            Spacer()
            
            Text("\(dateCompleString)")
                .font(.system(size: 12, weight: .semibold, design: .default))
            
            VStack {
                Text(" \(chore.value) p")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .padding(.bottom, 5)
                
                Text(" \(chore.timeSpent, specifier: "%.0f") m")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                
            }
            
        }.frame(height: 60)
            .onAppear {
                formatter.dateFormat = "HH:mm E, d MMM"
                self.dateCompleString = formatter.string(from: chore.timeCompleted ?? Date())
            }
    }
}

