//
//  TodoView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI

struct TodoView: View {
        
    @ObservedObject var vm = TodoViewModel()
    @ObservedObject var firHelper = FireBaseHelper()
    
    @EnvironmentObject var navManager: NavigationManager
            
    @State var goAddView = false
    @State var showAll = false
    @State var showComplete = false
    @State var fromAddView = true

    @State var tempChore = Chore()
    
    @State var currentDay = ""

    var body: some View {

        VStack(){
            
            Text("Week: \(Date().get(.weekOfYear)) Chores: \(vm.choresTodo.count)")

                List{
                    Section(header: Text("Monday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 2 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Tuesday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 3 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Wednesday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 4 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Thursday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 5 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Friday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 6 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Saturday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 7 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Sunday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dateToDo!.get(.weekday) == 1 && chore.dateToDo!.get(.weekOfYear) == Date().get(.weekOfYear) && chore.isCompleted == false{
                                
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    if showAll {
                        Section(header: Text("All chores")) {
                            ForEach(vm.choresTodo, id: \.id) { chore in
                                if chore.isCompleted == false {
                                    ChoreRow(chore: chore)
                                }
                            }.onDelete(perform: deleteChore)
                        }
                    }
                    
                    if showComplete {
                        Section(header: Text("Completed")) {
                            ForEach(vm.completedChores, id: \.id) { chore in
                                if chore.isCompleted == true{
                                    CompleteChoreRow(chore: chore).disabled(true)
                                        .deleteDisabled(true)
                                }
                            }.onDelete(perform: deleteChore)
                        }
                    }
                   
                }.listStyle(.plain)
                .refreshable {
                    if vm.isConnected {
                         vm.getFirChores(getCompleted: false, refresh: true)
                         vm.getFirChores(getCompleted: true, refresh: true)
                    } else {
                        vm.getCoreChores(getCompleted: false)
                        
                    }
                }
                
            if vm.isConnected {
                Divider().background(Color.blue)

                Text(" Pull to refresh ")
                    .font(.subheadline)
            }
            Divider().background(Color.blue)
                
            HStack {
                
                Button(action: {
                    navManager.goToAddChore()
                }) {
                    Text("Add chore")
                    .padding()
                    .frame(width: 180.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        self.showAll.toggle()
                    }
                }) {
                    Image(systemName: "list.bullet")
                        .padding()
                        .frame(width: 55.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .cornerRadius(10)
                    }
                Button(action: {
                    withAnimation {
                        self.showComplete.toggle()
                    }
                }) {
                    Image(systemName: "text.badge.checkmark")
                        .padding()
                        .frame(width: 55.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .cornerRadius(10)
                    }
            }
            
            }
            .onAppear(perform: {
                Task {
                    await vm.setConnection()
                }
                //vm.setCurrentWeek()

            })
            .navigationBarTitle("To do: \(navManager.path.count)", displayMode: .inline)
        .toolbar {
            EditButton()
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        offsets.forEach { index in
            let chore = vm.choresTodo[index]
            vm.removeChore(chore: chore)
            vm.choresTodo.remove(atOffsets: offsets)
        }
    }
}


struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            TodoView()
        }
    }
}

