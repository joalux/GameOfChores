//
//  templateMakerView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-08-26.
//

import SwiftUI


struct TemplateMakerView: View {
    @Environment(\.presentationMode) var presentatioMode

    @StateObject private var vm = TempleteMakerViewModel()
    @ObservedObject private var todoVM = TodoViewModel()
    
    @State var goAddView = false
    
    @State var showDay = false
    
    @State var weekDay: String = ""
    
    @State var currentDayIndex = 0
    
    @State var isEditing = false
    @State var editMode: EditMode = .inactive

    @State var fromAddView = false
    @State var newChore = Chore()
    
    var body: some View {
        VStack{
            NavigationLink(destination: AddChoreView(templateMode: true, newTempChore: $newChore, fromAddView: $fromAddView, weekDay: weekDay, dateToDo: Date()), isActive: $goAddView) { EmptyView() }
            VStack{
                Text("Add new template \(vm.templateChores.count)")
                    .font(.subheadline)
            }
                
                List {
                    Section("Monday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                                    TemplateChoreRow(chore: chore)
                                
                            
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section("Tuesday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Tuesday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }

                    Section("Wednesday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Wednesday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }

                    Section("Thursday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Thursday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section("Friday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Friday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section("Saturday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Saturday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section("Sunday") {
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Sunday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                  
                }.listStyle(.plain)
              
            .onAppear {
                print("____APPEAR!!!")
                vm.fetchChores()
            }
            
            Button {
                print("Adding chore")
             
                goAddView = true
            } label: {
                Text("+ chore")
                    .fontWeight(.bold)
            }.padding(.trailing)
            
            Divider()
        
            Spacer()
            Text("Swipe to delete chore")
            
            Button {
                print("Adding template")
                
                
            } label: {
                Text("Add template")
                    .padding()
                    .frame(width: 180.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .cornerRadius(10)
            }.padding(.bottom)

        }
      
        .navigationTitle("Create template")
    }
    
    func deleteChore(at offsets: IndexSet) {
        print("Removing chore!!")
        offsets.forEach { index in
            let chore = vm.templateChores[index]
            CoreDataManager.shared.removeChore(chore: chore)

        }
        vm.templateChores.remove(atOffsets: offsets)

    }
    
}

struct WeekDayView: View {
        
    var day: String
    @Binding var selectedDay: String

    @State var templateChores: [Chore]
    
    @State var showChores = false
    
    @State var editMode: EditMode = .inactive
    @State var isEditing = false
    
    @State var listHeight = 50.0
    
    @Binding var goAddview: Bool
    
    var body: some View {
            
            
            VStack {
                Divider()
                    .background(.blue)
                HStack {
                    Text(day)
                        .padding(.leading)
                    Text("CHORES: \(templateChores.count)")
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isEditing.toggle()
                            editMode = isEditing ? .active : .inactive
                        }
                        
                    } label: {
                        Text("Edit")
                            .font(.system(size: 19))
                    }
                    .contentShape(Rectangle())
                    .padding(.trailing)
                    
                    Button {
                        print("Adding chore")
                        selectedDay = day
                        goAddview = true
                    } label: {
                        Text("+ chore")
                    }.padding(.trailing)
                }
                .onAppear {
                    print("____Weekday = \(day) chores = \(templateChores.count)")
                   
                    listHeight = 50
                    if !templateChores.isEmpty {
                        print("Temchores not empty!!!")
                       // listHeight += 80
                    }
                    
                    for chore in templateChores {
                        print("Listheight \(day) = \(listHeight)")
                        
                        if chore.dayTodo == day {
                            listHeight += 80
                        }
                    }
                }
                
                Divider()
                    .background(.blue)
                List {
                    ForEach(templateChores, id: \.id){ chore in
                        if chore.dayTodo == day {
                            TemplateChoreRow(chore: chore)

                        }
                        
                    }.onDelete(perform: deleteChore)
                }.listStyle(.plain)
                .environment(\.editMode, $editMode)
          
        }
            .frame(height: listHeight)
    }
    
    func deleteChore(at offsets: IndexSet) {
        print("Removing chore!!")
        listHeight -= 70
       
        templateChores.remove(atOffsets: offsets)

    }
}

struct TemplateMakerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemplateMakerView(weekDay: "Monday")
        }
    }
}

