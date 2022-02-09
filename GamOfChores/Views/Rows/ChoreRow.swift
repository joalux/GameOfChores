//
//  ChoreRow.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI

struct ChoreRow: View {
    @StateObject var chore: Chore
    
    var body: some View {
      
        NavigationLink(destination: ChoreDetailView(selectedChore: chore)) {
            
        
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
            
            if chore.isCompleted {
                Text("Completed")
                    .font(.system(size: 12, weight: .semibold, design: .default))
            }
         
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
}

