//
//  AddChoreView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import SwiftUI
import CoreData

struct AddChoreView: View {
        
    @Environment(\.presentationMode) var presentatioMode
    @StateObject private var keyboardManager = KeyboardManager()
    
    @StateObject private var addChoreVM = AddChoreViewModel()
    @StateObject private var templateVM = TempleteMakerViewModel()

    @State var customChore = false
    @State var hasTimeLimit = false
    @State var hasDeadLine = false
    
    @State var templateMode: Bool = false
    @State var fromPlanner: Bool = false

    var dateToDo: Date? = Date()
        
    var body: some View {
        
        VStack {
            if templateMode {
                Text(addChoreVM.selectedDay.capitalizingFirstLetter())
                    .font(.system(size: 35, weight: .semibold, design: .default))

            }
            else {
                Text(addChoreVM.dayToDo.capitalizingFirstLetter())
                    .font(.system(size: 35, weight: .semibold, design: .default))
            }
            if !customChore {
                    VStack {
                        
                        Image(addChoreVM.type)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.bottom, 20)
                    }
            }
            else if customChore {
                Image("choreAlert")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom, 20)

            }
            if customChore {
              
                HStack {
                    Text("\(addChoreVM.customType) \(addChoreVM.selectedPoints, specifier: "%.0f")p")
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    if hasTimeLimit {
                        Text("\(addChoreVM.timeLimit, specifier: "%.0f") m")
                            .font(.system(size: 25, weight: .medium, design: .default))
                    }
                }
            }
            else {
                HStack {
                    Text("\(addChoreVM.type) \(addChoreVM.selectedPoints, specifier: "%.0f") p")
                            .font(.system(size: 25, weight: .medium, design: .default))
                    if hasTimeLimit {
                        Text("\(addChoreVM.timeLimit, specifier: "%.0f") m")
                            .font(.system(size: 25, weight: .medium, design: .default))
                    }
                }
            }
            
            Divider().background(Color.blue)

            if customChore {
                
                TextField("Chore", text: $addChoreVM.customType)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
                    .padding(.leading, 80)
                    .padding(.trailing, 80)
                Text("Enter new chore type")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .disableAutocorrection(true)
                    
                    .padding(.bottom)
            } else {
                Text("Tap to select chore")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                Picker("Tap to select chore", selection: $addChoreVM.type) {
                    ForEach(addChoreVM.types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                if templateMode {
                    Text("Tap to select day")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    Picker("Tap to select day", selection: $addChoreVM.selectedDay) {
                        ForEach(templateVM.weekDaysFull, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            VStack() {
            
                VStack(spacing: -10) {
                    Stepper("Points", onIncrement: {
                        addChoreVM.selectedPoints += 10
                        },
                        onDecrement: {
                            if addChoreVM.selectedPoints > 0 {
                                addChoreVM.selectedPoints -= 10
                            }
                    }).frame(width: 200, height: 50, alignment: .center)
                
                    Stepper("Time limit", onIncrement: {
                            addChoreVM.timeLimit += 5
                            }, onDecrement: {
                                if addChoreVM.timeLimit > 0 {
                                    addChoreVM.timeLimit -= 5
                                }
                        }).frame(width: 200, height: 50, alignment: .center)
                            .disabled(hasTimeLimit == false)
                    
                }
                
                if hasDeadLine && templateMode == false {
                    DatePicker("Select date:", selection: $addChoreVM.dateToDo, in: Date()...)
                        .onChange(of: addChoreVM.dateToDo, perform: { newDate in
                            print("new date: \(newDate)")
                            addChoreVM.setDate(newDate: newDate)
                        })
                    
                        .padding()
                        .padding(.horizontal)
                        
                }
                else if templateMode == false {
                    DatePicker("Select date:", selection: $addChoreVM.dateToDo, displayedComponents: .date)
                        .onChange(of: addChoreVM.dateToDo, perform: { newDate in
                            print("new date: \(newDate)")
                            addChoreVM.setDate(newDate: newDate)
                        })
                        .padding()
                        .padding(.horizontal, 60)
                }
            
                Divider().background(Color.blue)

                HStack {
                    Button(action: {
                        print("Custom chore!!")
                        withAnimation {
                            customChore.toggle()
                        }
                    }) {
                        Text("New chore")
                            .frame(width: 110.0, height: 40.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    }
                
                    Button(action: {
                        print("TimeLimit!!")
                        withAnimation {
                            hasTimeLimit.toggle()

                        }
                    }) {
                        Text("Time limit")
                            .frame(width: 110.0, height: 40.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .cornerRadius(10)
                    }
                 
                    if templateMode == false {
                        Button(action: {
                            print("DEADLINE!!")
                            withAnimation {
                                hasDeadLine.toggle()

                            }
                        }) {
                            Text("Deadline")
                                .frame(width: 110.0, height: 40.0)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        
            Divider().background(Color.blue)
         
            Button(action: {
                print("____Adding new chore!")
                
                if customChore && addChoreVM.customType.isEmpty == false {
                    addChoreVM.addNewChore(isCustom: customChore, templateMode: templateMode)
                                       
                    presentatioMode.wrappedValue.dismiss()

                } else if customChore == false {
                    addChoreVM.addNewChore(isCustom: customChore, templateMode: templateMode)
                    
                    presentatioMode.wrappedValue.dismiss()

                }
            }) {
                Text("Add chore")
                    .padding()
                    .frame(width: 180.0, height: 45.0)
                    .background(addChoreVM.selectedPoints > 0 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .cornerRadius(10)
            }.disabled(addChoreVM.customChore && addChoreVM.customType.isEmpty || addChoreVM.selectedPoints == 0)
               // .padding(.top, 5)
            
        }
        .padding(.bottom, keyboardManager.keyboardHeight + 100)
        .onAppear {
            print("_____Date to do: \(dateToDo)")
            if let dateToDo = dateToDo {
                addChoreVM.dateToDo = dateToDo
            }
           
            if let dateToDo = dateToDo {
                addChoreVM.setDate(newDate: dateToDo)
            }
            
            
            print(addChoreVM.activeFamily)
            print(addChoreVM.dateToDo)
        }
    }
      
    }

