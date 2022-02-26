//
//  PlannerView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-23.
//

import SwiftUI
import CoreData



struct PlannerView: View {
    
    @StateObject private var vm = PlannerViewModel()
    
    @State var index = 6
    @State var currentDayIndex = 0
        
    var body: some View {
        
        VStack {
            TabView(selection: $currentDayIndex) {
                dayView(weekDay: vm.weekDaysFull[currentDayIndex],chores: vm.chores, index: $currentDayIndex)
                .tag(0)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(1)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(2)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(3)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(4)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(5)
                dayView(weekDay: vm.weekDaysFull[currentDayIndex], chores: vm.chores, index: $currentDayIndex)
                .tag(6)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            WeekDaysRow(dayIndex: $currentDayIndex)
        }
        .onAppear {
            print("______PLANNER APPEAR_______")
            vm.fetchChores()
           vm.getDayOfWeek()
        }
    }
}


struct dayView: View {
    
    var weekDay: String
    var chores = [Chore]()
    
    @Binding var index: Int
    
    @State var goAddView = false
    @State var showComplete = false
    
    @ObservedObject private var vm = TodoViewModel()
    
    var body: some View {
        VStack {
            NavigationLink(destination: AddChoreView(weekDay: weekDay), isActive: $goAddView) { EmptyView() }
            
            Text("\(weekDay)")
                .font(.system(size: 35, weight: .bold, design: .default))
            Divider().background(Color.blue)

            List {
                Section(header: Text("To do")) {
                    ForEach(chores, id: \.id) { chore in
                        if chore.dayTodo == weekDay && chore.isCompleted == false{
                            ChoreRow(chore: chore)
                        }
                    }.onDelete(perform: deleteChore)
                }
                Section(header: Text("Completed chore")) {
                    ForEach(chores, id: \.id) { chore in
                       if chore.dayTodo == weekDay && chore.isCompleted == true{
                            ChoreRow(chore: chore).disabled(chore.isCompleted)
                        }
                    }
                }
              
            }.listStyle(.plain)
                .padding(.top, -10)
            
            Divider().background(Color.blue)
            
            Text("<- Swipe to change day ->")
            
            Button(action: {
                print("Adding chore")
                print(weekDay)
                goAddView = true
                
                }) {
                    Text("Add chore")
                    .padding()
                    .frame(width: 180.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                }
        }.padding(.bottom, 5)
            /*.sheet(isPresented: $goAddView, onDismiss: {
                print("Dismissing!_______________!")
                //vm.fetchChores()
            }) {
                AddChoreView(weekDay: weekDay)
            }*/
            .onAppear {
               // vm.dayTodo = weekDay
                
               // vm.chores = chores
                
                //vm.fetchChores()
            }
        .toolbar {
            EditButton()
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        offsets.forEach { index in
            let chore = chores[index]
            
            vm.removeChore(chore: chore)
            
        }
    }
}
