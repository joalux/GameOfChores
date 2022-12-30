//
//  PlannerView2.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-19.
//

import SwiftUI

struct PlannerView2: View {
    
    @ObservedObject private var vm2 = PlannerViewModel2()
    
    @State var goAddView = false
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm2.months) { month in
                    MonthView(month: month, selectedDate: month.firstDay)
                }
            }
        }
    }
}

struct MonthView: View {
    
    @ObservedObject private var vm = PlannerViewModel()
    
    @StateObject var month: Month
    
    @State var selectedDate: Date
    @State var tempChore = Chore()
    
   // @Binding var chores: [Chore]
    @State var monthChores = [Chore]()
    
    @State var goAddView = false
    @State var fromAddView = false
    @State var fromPlanner = false
    
    @State var noChores = false
    @State var showChores = false
    @State var showAll = false
    
    @State var allListHeight: Double = 0
    @State var dayListHeight: Double = 0

    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Chores: \(vm.dayChores.count) List H: \(vm.listHeight) ")
                        .padding(.trailing)
                        .font(Font.headline.weight(.bold))

                    Spacer()
                    Button {
                        print("Selected date: ", selectedDate)
                        for chore in vm.monthChores {
                            print(chore.dateToDo)
                            if let dateToDo = chore.dateToDo {
                                print("TIMESTAMP = ",vm.removeTimeStamp(fromDate: dateToDo))
                            }
                        }
                        vm.getDayChores(selectedDay: selectedDate)
                        withAnimation {
                            showChores.toggle()
                        }
                    } label: {
                        Image(systemName: "list.bullet.below.rectangle")
                            .resizable()
                            .frame(width: 22.0, height: 22.0)
                        
                    }.padding(.trailing)
                    
                    Button {
                        print("Adding core!!")
                        goAddView = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 22.0, height: 22.0)
                    }
                }.padding(.trailing)
                
                DatePicker(
                    "Start Date",
                    selection: $selectedDate,
                    in: month.monthRange,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .onChange(of: selectedDate, perform: { newDate in
                   print("New date: ", newDate)
                    print("New day: ", vm.removeTimeStamp(fromDate: newDate).get(.day))
                    print("SETTING DAY CHORES")
                    vm.setDayChores(selectedDay: newDate)
                    print("DAY CHORES SET: ", vm.dayChores.count)
                                        
                    print("_______CHORELIST_______")
                    print("Selected: ", selectedDate.get(.day))
                    for chore in vm.dayChores {
                        print(chore.dateToDo)
                        print(chore.dateToDo!.get(.day))
                        
                    }
                    print("Has daychores!!", vm.dayChores.count)
                    print("List height:", dayListHeight)
                    
                })
                .onAppear {
                    print("___PLANNER APPEAR____")
                    vm.fetchChores()
                    vm.getDayChores(selectedDay: selectedDate)

                }
                Divider()
                    .background(.blue)
                
                if showChores {
                    Group {
                        
                        VStack {
                            Text("To do: \(vm.dayChores.count), height: \(Double(vm.dayChores.count * 85))")
                                .onAppear {
                                    for chore in vm.dayChores {
                                        print("Day = ", chore.dateToDo!.get(.day))

                                    }
                                }
                            if noChores {
                                Text("No chores")
                                    .font(.title)
                            }
                        
                                ForEach(vm.dayChores, id: \.id) { chore in
                                    
                                    ChoreRow(chore: chore)
                                        .padding(.horizontal)
                                    
                                    
                                }
                            .padding(.bottom)
                            .padding(.top)
                            .onAppear {
                                print("_______CHORELIST_______")
                                print("Selected: ", selectedDate.get(.day))
                                for chore in vm.dayChores {
                                    print(chore.dateToDo)
                                    print(chore.dateToDo!.get(.day))
                                    
                                }
                                print("Has daychores!!", vm.dayChores.count)
                            }
                        }
                     
                      
                        
                        Group {
                            
                        Divider()
                            .background(.blue)

                        HStack {
                            Text("Show all")
                                .padding(.leading)
                            Spacer()
                            if showAll {
                                Image(systemName: "chevron.up")
                            }
                            else {
                                Image(systemName: "chevron.down")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("___SHOWING ALL CHORES!!")
                            print("___LISTHEIGHT: ", allListHeight)
                            withAnimation {
                                showAll.toggle()
                            }
                        }
                        .padding(.trailing)
                        
                        if showAll {
                            List {
                                if vm.monthChores.isEmpty {
                                    Text("No chores!")
                                        .padding()
                                }
                                ForEach(vm.monthChores, id: \.id) { chore in
                                    ChoreRow(chore: chore)
                                }

                            }.listStyle(.plain)
                                //.frame(height: vm.monthChores.isEmpty ? 80 : 200)

                        }
                    }
                        Divider()
                            .background(.blue)

                        //.frame(height: showAll ? 350 : 300)
                       /* VStack {
                            List {
                                
                                ForEach(chores, id: \.id) { chore in
                                    if let dateTodo = chore.dateToDo {
                                        if dateTodo.get(.month) == selectedDate.get(.month) && dateTodo.get(.day) == selectedDate.get(.day) {
                                            ChoreRow(chore: chore)
                                            
                                        }
                                    }
                                }
                                
                                HStack {
                                    Text("Show all")
                                    Spacer()
                                    if showAll {
                                        Image(systemName: "chevron.up")
                                    }
                                    else {
                                        Image(systemName: "chevron.down")
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print("SHOWING ALL CHORES!!")
                                    withAnimation {
                                        showAll.toggle()
                                    }
                                }
                                .padding(.trailing)
                                
                                if showAll {
                                    ForEach(chores, id: \.id) { chore in
                                        if let dateTodo = chore.dateToDo {
                                            if dateTodo.get(.month) == selectedDate.get(.month){
                                                ChoreRow(chore: chore)
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }.frame(height: showAll ? 350 : 300)
                                .listStyle(.plain)
                        }.frame(height: showChores ? 600 : 300)*/
                        
                    }
                }
            }
        }
        Divider()
            .padding(.bottom)
            
    }
}


struct PlannerView2_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView2()
    }
}
