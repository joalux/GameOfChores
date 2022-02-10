//
//  TodoView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI

struct TodoView: View {
        
    @ObservedObject var vm = TodoViewModel()
        
    @State var showingAddSheet = false
    @State var showAddView = false
    
    @State var goAddView = false
    @State var showComplete = false
    
    @State var currentDay = ""

    var body: some View {

            VStack{
                
                NavigationLink(destination: AddChoreView(weekDay: currentDay), isActive: $goAddView) { EmptyView() }


                List{
                    Section(header: Text("Monday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Monday" {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Tuesday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Tuesday" {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Wednesday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Wednesday" {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Thursday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Thursday" {
                                ChoreRow(chore: chore)
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    Section(header: Text("Friday")) {
                        ForEach(vm.chores, id: \.id) { chore in
                            if chore.dayTodo == "Friday" {
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
                }.listStyle(.plain)
                
                Divider().background(Color.blue)

                Text(" Swipe to delete chore ")
                    .font(.subheadline)
                
                Button(action: {
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
