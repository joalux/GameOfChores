//
//  PlannerView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-23.
//

import SwiftUI
import CoreData



struct PlannerView: View {
    
    @ObservedObject private var vm = PlannerViewModel()
    
    @State var index = 6
    
    var body: some View {
        
        VStack {
            TabView(selection: $vm.currentDayIndex) {
                dayView(weekDay: "Monday",chores: vm.chores, index: $vm.currentDayIndex)
                .tag(1)
                dayView(weekDay: "Tuesday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(2)
                dayView(weekDay: "Wednesday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(3)
                dayView(weekDay: "Thursday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(4)
                dayView(weekDay: "Friday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(5)
                dayView(weekDay: "Saturday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(6)
                dayView(weekDay: "Sunday", chores: vm.chores, index: $vm.currentDayIndex)
                .tag(7)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .onAppear {
            vm.fetchChores()
           vm.getDayOfWeek()
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}

struct dayView: View {
    
    var weekDay: String
    var chores = [Chore]()
    
    @Binding var index: Int
    
    @State var goAddView = false
    
    @ObservedObject private var vm = TodoViewModel()
    
    var body: some View {
        VStack {
           // NavigationLink(destination: AddChoreView(weekDay: weekDay), isActive: $goAddView) { EmptyView() }
            
            Text("\(weekDay)")
                .font(.system(size: 35, weight: .bold, design: .default))
            Divider().background(Color.blue)

            List {
                ForEach(vm.chores, id: \.id) { chore in
                    if chore.dayTodo == weekDay {
                        ChoreRow(chore: chore)
                    }
                    
                }.onDelete(perform: deleteChore)
            }.listStyle(.plain)
            
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
        }.padding(.bottom, 45)
            .sheet(isPresented: $goAddView, onDismiss: {
                print("Dismissing!!")
                vm.fetchChores()
            }) {
                AddChoreView(weekDay: weekDay)
            }
            .onAppear {
               // vm.dayTodo = weekDay
                
               // vm.chores = chores
                
                vm.fetchChores()
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
