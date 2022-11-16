//
//  ChoreRow.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI

struct ChoreRow: View {
    @StateObject var chore: Chore
    
    let formatter = DateFormatter()
    @State var dateCompleString = ""
    
    @State var goDetail: Bool = false
    
    var body: some View {
      
        NavigationLink(destination: ChoreDetailView(selectedChore: chore), isActive: $goDetail) {
            
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
                Text("\(dateCompleString)")
                    .font(.system(size: 12, weight: .semibold, design: .default))
                
                VStack {
                    Text(" \(chore.value) p")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                        .padding(.bottom, 5)
               
                        Text(" \(chore.timeSpent, specifier: "%.0f") m")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                    
                }
            }
                else {
                    if let dateTodo = chore.dateToDo {
                        Text("W: \(dateTodo.get(.weekOfYear)), D: \(dateTodo.get(.weekday))")

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
                }
            }.frame(height: 60)
        }.onTapGesture {
            goDetail = true
        }
        .onAppear {
            formatter.dateFormat = "HH:mm E, d MMM"
            if chore.timeCompleted != nil {
                self.dateCompleString = formatter.string(from: chore.timeCompleted!)
            }
        }
    }
}

