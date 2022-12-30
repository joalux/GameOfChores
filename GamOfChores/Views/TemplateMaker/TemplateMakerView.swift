//
//  templateMakerView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-08-26.
//

import SwiftUI
import UIKit
/*
struct TemplateMakerView: View {
    @Environment(\.presentationMode) var presentatioMode

    @StateObject private var vm = TempleteMakerViewModel()
    @ObservedObject private var todoVM = TodoViewModel()
    
    @State var goAddView = false
    
    @State var showDay = false
            
    @State var isEditing = false
    @State var editMode: EditMode = .inactive

    @State var fromAddView = false
    @State var newChore = Chore()
    @State var selectedDay = ""
        
    var body: some View {
        VStack{
            NavigationLink(destination: AddChoreView(templateMode: true, newTempChore: $newChore, fromAddView: $fromAddView, dateToDo: Date()), isActive: $goAddView) { EmptyView() }
            VStack{
                Text("Add new template \(vm.templateChores.count)")
                    .font(.subheadline)
            }
                List {
                    Section() {
                        HStack {
                            Text("Monday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Monday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                    
                            }.padding(.trailing)
                        }
                          
                        
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Monday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section() {
                        HStack {
                            Text("Tuesday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Tuesday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Tuesday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }

                    Section() {
                        HStack {
                            Text("Wednesday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Wednesday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Wednesday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }

                    Section() {
                        HStack {
                            Text("Thursday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Thursday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
                        
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Thursday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section() {
                        HStack {
                            Text("Friday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Friday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Friday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section() {
                        HStack {
                            Text("Saturday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Saturday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
                        ForEach(vm.templateChores, id: \.id) {chore in
                            if let dayTodo = chore.dayTodo {
                                if dayTodo == "Saturday" {
                                    TemplateChoreRow(chore: chore)
                                }
                            }
                        }.onDelete(perform: deleteChore)
                    }
                    
                    Section() {
                        HStack {
                            Text("Sunday")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.gray))
                            Spacer()
                            Button {
                                print("Adding chore")
                                selectedDay = "Sunday"
                                goAddView = true
                            } label: {
                                Text("+ chore")
                                    .font(.headline)
                                
                            }.padding(.trailing)
                        }
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
            
            Divider()
        
            Spacer()
            Text("Swipe to delete chore")
            
            Button {
                print("Adding template")
                self.presentatioMode.wrappedValue.dismiss()
                
            } label: {
                Text("Save template")
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

struct TemplateMakerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemplateMakerView()
        }
    }
}

*/
