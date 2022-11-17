//
//  PlannerView2.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-19.
//

import SwiftUI

struct PlannerView2: View {
    
    @ObservedObject private var vm = PlannerViewModel()
    @ObservedObject private var vm2 = PlannerViewModel2()
    
    @State var goAddView = false
    
    var body: some View {
        VStack {
            Text("Listheight: \(vm.listHeight)")
            ScrollView {
                ForEach(vm2.months) { month in
                    MonthView(month: month, selectedDate: month.firstDay, chores: $vm.chores, listHeight: $vm.listHeight)
                }
            }
        }
        .onAppear {
            vm.fetchChores()
            
        }
    }
}

struct MonthView: View {
    
    @StateObject var month: Month
    
    @State var selectedDate: Date
    @State var tempChore = Chore()
    
    @Binding var chores: [Chore]
    @State var monthChores = [Chore]()
    
    @State var goAddView = false
    @State var fromAddView = false
    @State var fromPlanner = false
    
    @State var noChores = false
    @State var showChores = false
    @State var showAll = false
    
    @Binding var listHeight: Double
    
    var body: some View {
        VStack {
            NavigationLink(destination: AddChoreView(fromPlanner: fromPlanner, newTempChore: $tempChore, fromAddView: $fromAddView, dateToDo: selectedDate), isActive: $goAddView) { EmptyView() }
            VStack {
                HStack {
                    Spacer()
                    Text("Chores: \(monthChores.count) List H: \(listHeight) ")
                        .padding(.trailing)
                        .font(Font.headline.weight(.bold))

                    Spacer()
                    Button {
                        print("Selected date: ", selectedDate)
                        for chore in chores {
                            print(chore.dateToDo)
                        }
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
                   print(newDate)
                 
                    
                })
                .onAppear {
                    
                    for chore in chores {
                        if let choreDate = chore.dateToDo {
                            if choreDate.get(.month) == selectedDate.get(.month) && monthChores.contains(chore) == false {
                                monthChores.append(chore)
                            }
                        }
                    }

                }
                Divider()
                
                if showChores {
                    Group {
                        Text("To do")
                        if noChores {
                            Text("No chores")
                                .font(.title)
                        }
                        List {
                            ForEach(chores, id: \.id) { chore in
                                if let dateTodo = chore.dateToDo {
                                    if dateTodo.get(.month) == selectedDate.get(.month) && dateTodo.get(.day) == selectedDate.get(.day) {
                                        ChoreRow(chore: chore)
                                        
                                    }
                                }
                            }
                        }.listStyle(.plain)
                        
                        Group {
                            
                        
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
                            print("___SHOWING ALL CHORES!!")
                            print("___LISTHEIGHT: ", listHeight)
                            listHeight = listHeight / 8
                            withAnimation {
                                showAll.toggle()
                            }
                        }
                        .padding(.trailing)
                        
                        if showAll {
                            List {
                                ForEach(chores, id: \.id) { chore in
                                    if let dateTodo = chore.dateToDo {
                                        if dateTodo.get(.month) == selectedDate.get(.month){
                                            ChoreRow(chore: chore)
                                            
                                        }
                                    }
                                }

                            }.listStyle(.plain)
                            .frame(height: listHeight)

                        }
                    }
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
