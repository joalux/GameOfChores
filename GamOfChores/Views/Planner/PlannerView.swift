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
    @State var currentMonthIndex = 0
    
    @State var todayIndex = 0
    @State var newDayIndex = 0

    @State var currentDate = Date()
    @State var selectedDate = Date()
    
    @State var goAddView = false
    @State var showCalendar = false
    @State var goCreateTemplate = false
    @State var fromAddView = true
    
    @State var selectedMonth = ""
    let dateFormatter = DateFormatter()

    @State var tempChore = Chore()

        
    var body: some View {
   
        VStack {
            
            NavigationLink(destination: AddChoreView(templateMode: false, newTempChore: $tempChore, fromAddView: $fromAddView, weekDay: dateFormatter.string(from: selectedDate).capitalizingFirstLetter(), dateToDo: selectedDate), isActive: $goAddView) { EmptyView() }

            NavigationLink(destination: TemplateMakerView(), isActive: $goCreateTemplate) { EmptyView() }
            
            if showCalendar {
                DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onReceive([self.selectedDate].publisher.first()) { newDate in
                        print("____new date = \(newDate)")
                    }
                    
                Button {
                    print("_____Closing calendar")
                    withAnimation {
                        showCalendar.toggle()
                    }
                } label: {
                    Text("Close")
                        .frame(width: 90.0, height: 40.0, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
            }
            Text("\(dateFormatter.string(from: selectedDate).capitalizingFirstLetter()) \(selectedDate.get(.day))/\(selectedDate.get(.month))")
                .font(.system(size: 35, weight: .bold, design: .default))
                .padding(.leading)

            TabView(selection: $currentDayIndex) {
                dayView(weekDay: vm.weekDaysFull[todayIndex],chores: $vm.chores, selectedDate: $selectedDate)
                .tag(-1)
                dayView(weekDay: vm.weekDaysFull[todayIndex],chores: $vm.chores, selectedDate: $selectedDate)
                .tag(0)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(1)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(2)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(3)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(4)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(5)
                dayView(weekDay: vm.weekDaysFull[todayIndex], chores: $vm.chores, selectedDate: $selectedDate)
                .tag(6)
                dayView(weekDay: vm.weekDaysFull[todayIndex],chores: $vm.chores, selectedDate: $selectedDate)
                .tag(7)
            }
            .onChange(of: currentDayIndex, perform: { dayIndex in
                                
                if dayIndex > todayIndex {
                    print("__swiped right!!")
                    
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)
                    if let tomorrow = tomorrow {
                        print("__TOMORROW ==== \(dateFormatter.string(from: tomorrow)))")
                        selectedDate = tomorrow
                    }
                    
                    if todayIndex == 6 {
                        print("____ NEW WEEK")
                        todayIndex = 0
                        currentDayIndex = 0
                    }
                    else {
                        todayIndex = dayIndex
                    }
                    
                }
                else if dayIndex < todayIndex {
                    print("__swiped left!!")
                    
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)
                    if let yesterday = yesterday {
                        print("__YESTERDAY ==== \(dateFormatter.string(from: yesterday)))")
                        selectedDate = yesterday

                    }
                    
                    if dayIndex == 0 || dayIndex == -1{
                        print("____ LAST WEEK")
                        todayIndex = 6
                        currentDayIndex = 6
                    }
                    else {
                        print("____Previous week DAYINIDEX = \(dayIndex)!!")
                        todayIndex = dayIndex
                    }

                }
                
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationBarTitle("Planner", displayMode: .inline)
           
        
            Divider().background(Color.blue)
            HStack {
                Button {
                    print("Adding chore")
                    goAddView = true
                } label: {
                    Text("Add chore")
                        .frame(width: 180.0, height: 45.0, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
                VStack(alignment: .center, spacing: 1) {
                    Button{
                        print("Showing calendar")
                        withAnimation {
                            showCalendar.toggle()
                        }
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .frame(width: 45.0, height: 45.0, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    Text("   Select \n     day")
                        .font(.subheadline)
                        .lineLimit(2)
                        

                }
               
                VStack(alignment: .center, spacing: 1) {
                    Button{
                        print("____Showing template create")
                        goCreateTemplate = true
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .frame(width: 45.0, height: 45.0, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    Text("   Create \n template")
                        .lineLimit(2)
                        .font(.subheadline)
                    
                }
            }
        }
        .onAppear {
            dateFormatter.dateFormat = "EEEE"
            
            print("___APPEAR DAYINDEX = \(currentDayIndex)")
            
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct dayView: View {
    
    var weekDay: String
    @Binding var chores: [Chore]
    
    @State var todaysChores: [Chore] = []
    
    @Binding var selectedDate: Date
    
    let dateFormatter = DateFormatter()
    
    @State var showCompleted = false
    
    @ObservedObject private var vm = TodoViewModel()
    
    @State var editMode: EditMode = .inactive
    @State var isEditing = false

    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack() {
                Text("Chores = \(chores.count), day = \(selectedDate.get(.day)), mont = \(selectedDate.get(.month))")
                Spacer()
                Button {
                    withAnimation {
                        isEditing.toggle()
                        editMode = isEditing ? .active : .inactive
                    }

                } label: {
                    Text("Edit")
                        .font(.system(size: 19))
                }.padding(.bottom)
                .padding(.trailing)
            }
            Divider()
            List {
                ForEach(chores, id: \.id){ chore in
                        if chore.dateToDo?.get(.day) == selectedDate.get(.day) && chore.dateToDo?.get(.month) == selectedDate.get(.month) && chore.isCompleted == false{
                            ChoreRow(chore: chore)
                        }
                    }.onDelete(perform: deleteChore)
                
            }.listStyle(.plain)
            .environment(\.editMode, $editMode)
            
            Divider().background(Color.blue)
            
            Text("<- Swipe to change day ->")
                .padding(.top, 5)
            
        }.padding(.bottom, 4)
        .onAppear {
            print("_____DAYVIEW APPEAR DAY = \(selectedDate.get(.day))")
            
            
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


