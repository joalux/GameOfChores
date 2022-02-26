//
//  TodoView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI

struct TodoView: View {
        
    @StateObject var vm = TodoViewModel()
        
    @State var showingAddSheet = false
    @State var showAddView = false
    
    @State var goAddView = false
    @State var showComplete = false
    
    @State var currentDay = ""

    var body: some View {

        VStack(spacing: 10){
                
                NavigationLink(destination: AddChoreView(weekDay: vm.dayTodo), isActive: $goAddView) { EmptyView() }


                List{
                    Section(header: Text("Monday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Monday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Tuesday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Tuesday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Wednesday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Wednesday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Thursday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Thursday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Friday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Friday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Saturday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Saturday" && chore.isCompleted == false {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Sunday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Sunday" && chore.isCompleted == false{
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    if showComplete {
                        Section(header: Text("Completed")) {
                            ForEach(vm.chores, id: \.id) { chore in
                                if chore.isCompleted == true{
                                    CompleteChoreRow(chore: chore).disabled(true)
                                }
                            }.onDelete(perform: deleteChore)
                        }
                    }
                   
                }.listStyle(.plain)
                
       
            
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
                    .padding(.leading, 70)
                VStack(alignment: .center, spacing: 1) {
                    Text("show completed").font(.footnote)
                        .padding(.trailing,3)
                    Toggle("", isOn: $showComplete.animation(.spring()))
                        .padding(.trailing,40)
                        
                }
            }
            }
            .onAppear(perform: {
                print("Appear!!!!!!!!")
                vm.fetchChores()
            })
            .navigationBarTitle("To do", displayMode: .automatic)
        .toolbar {
            EditButton()
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        offsets.forEach { index in
            let chore = vm.chores[index]
            
            vm.removeChore(chore: chore)
            
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = CoreDataManager.shared.container.viewContext

        //NavigationView {
            TodoView()
        //}
    }
}
