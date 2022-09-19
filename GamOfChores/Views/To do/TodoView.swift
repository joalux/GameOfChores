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
        
    @State var showingAddSheet = false
    @State var showAddView = false
    
    @State var goAddView = false
    @State var showComplete = false
    @State var fromAddView = true

    @State var tempChore = Chore()
    
    @State var currentDay = ""
    
    

    var body: some View {

        VStack(){
            NavigationLink(destination: AddChoreView(newTempChore: $tempChore, fromAddView: $fromAddView , weekDay: vm.dayTodo, dateToDo: Date()), isActive: $goAddView) { EmptyView() }
            
                List{
                    Section(header: Text("Monday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Monday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Tuesday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Tuesday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Wednesday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Wednesday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Thursday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Thursday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Friday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Friday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Saturday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Saturday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Sunday")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                            if chore.dayTodo == "Sunday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section(header: Text("All chores")) {
                        ForEach(vm.choresTodo, id: \.id) { chore in
                           if chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
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
                        await vm.getFirChores(getCompleted: false, refresh: true)
                        await vm.getFirChores(getCompleted: true, refresh: true)
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

            Text(" Swipe to delete chore ")
                .font(.subheadline)
                
            HStack {
                Button(action: {
                        vm.setCurrentDay()
                        self.goAddView = true
                        }) {
                            Text("Add chore")
                            .padding()
                            .frame(width: 180.0, height: 45.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 60)
                
                VStack(alignment: .center, spacing: 4) {
                    Toggle("", isOn: $showComplete.animation(.spring()))
                        .onChange(of: showComplete) { value in
                            print("SHOW COMPLETE \(value)")
                        }
                        .padding(.trailing,40)
                    
                    Text("show completed").font(.footnote)
                        .padding(.trailing,3)

                }
            }
            }
            .onAppear(perform: {
                Task {
                    await vm.setConnection()
                }
            })
            .navigationBarTitle("To do", displayMode: .inline)
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
        
        let context = CoreDataManager.shared.container.viewContext

        TodoView()
    }
}
