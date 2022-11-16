//
//  DayView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-17.
//

import SwiftUI

struct DayView: View {
    @Binding var chores: [Chore]
        
    @Binding var selectedDate: Date
    
    @State var todaysChores = [Chore]()
    
    let dateFormatter = DateFormatter()
    
    @State var showCompleted = false
    
    @StateObject private var vm = TodoViewModel()
    
    var body: some View {
       
        VStack(spacing: 0) {
            HStack() {
                Spacer()
                EditButton()
                    .padding(.trailing)
            }
            Divider()
                 
            List {
                ForEach(chores, id: \.id){ chore in
                    if vm.removeTimeStamp(fromDate: chore.dateToDo!)  == vm.removeTimeStamp(fromDate: selectedDate) {
                        ChoreRow(chore: chore)
                    }
                    
                }.onDelete(perform: deleteChore)
                
            }.listStyle(.plain)
                
          
            Divider().background(Color.blue)
            
            Text("<- Swipe to change day ->")
                .padding(.top, 5)
            
        }.padding(.bottom, 4)
            
        .onAppear {
            for chore in chores {
             
                if let choreDateToDo = chore.dateToDo {
                    if choreDateToDo.get(.month) == selectedDate.get(.month) {
                      
                        if choreDateToDo.get(.day) == selectedDate.get(.day) {
                        
                            todaysChores.append(chore)
                        }
                    }
                }
            }
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        offsets.forEach { index in
            let chore = chores[index]
            
            vm.removeChore(chore: chore)
            
        }
        chores.remove(atOffsets: offsets)

    }
}


