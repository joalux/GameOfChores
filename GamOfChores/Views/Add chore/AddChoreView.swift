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
   // @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var vm = AddChoreViewModel()
        
    @State var customChore = false
    @State var hasTimeLimit = false
    
   var weekDay: String? = ""
    
    /*
    init(vm: AddChoreViewModel){
        self.vm = vm
    }*/
    //Accessing State's value outside of being installed on a View. This will result in a constant Binding of the initial value and will not update.
    
    var body: some View {
        
        VStack {
            Text(vm.dayToDo)
                .font(.system(size: 35, weight: .semibold, design: .default))
            if !customChore {
                    VStack {
                        TabView(selection: $vm.selectedType) {
                            ForEach(0..<vm.types.count) { num in
                                Image(vm.types[num])
                                    .resizable()
                                    .scaledToFit()
                                    .tag(num)
                                    .padding(.bottom, 20)
                            }
                        }.tabViewStyle(PageTabViewStyle())
                            .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
                        Text("<- swipe to select chore ->")
                            .foregroundColor(.gray)
                            .padding(.bottom)
                    }
            }
            else if customChore {
                Image("choreAlert")
                /*
                TextField("Chore", text: $vm.customType)
                    .padding(.leading, 90)
                    .padding(.trailing, 90)
                Text("Enter new chore type")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding(.bottom)*/

            }
            if customChore {
              
                HStack {
                    Text("\(vm.customType) \(vm.selectedPoints, specifier: "%.0f")p")
                        .font(.system(size: 25, weight: .medium, design: .default))
                    
                    if hasTimeLimit {
                        Text(vm.choreTimeLimitString(timeLimit: vm.timeLimit))
                            .font(.system(size: 25, weight: .medium, design: .default))
                    }
                }
                
            }
            else {
                HStack {
                    Text("\(vm.types[vm.selectedType]) \(vm.selectedPoints, specifier: "%.0f") p")
                            .font(.system(size: 25, weight: .medium, design: .default))
                    if hasTimeLimit {
                        Text("\(vm.timeLimit, specifier: "%.0f") m")
                            .font(.system(size: 25, weight: .medium, design: .default))
                    }
                    
                }
            }
            
            Divider().background(Color.blue)

            if customChore {
                TextField("Chore", text: $vm.customType)
                    .padding(.top)
                    .padding(.leading, 90)
                    .padding(.trailing, 90)
                Text("Enter new chore type")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    .padding(.bottom)
            }
            
            VStack(spacing: -20) {
                
               
                Toggle("New chore", isOn: $customChore.animation(.spring()))
                        .padding()
                    .padding(.horizontal, 100)
                Toggle("Timelimit", isOn: $hasTimeLimit.animation(.spring()))
                        .padding()
                    .padding(.horizontal, 100)
                
            }
            
            Stepper("Points", onIncrement: {
                vm.selectedPoints += 10
                   print("Adding to points")
                }, onDecrement: {
                    vm.selectedPoints -= 10
                    print("Subtracting from points")
            }).frame(width: 200, height: 50, alignment: .center)
            
            if hasTimeLimit {
                Stepper("Time limit", onIncrement: {
                    vm.timeLimit += 5
                       print("Adding time")
                    
                    }, onDecrement: {
                        vm.timeLimit -= 5
                        print("Subtracting time")
                }).frame(width: 200, height: 50, alignment: .center)
            }
            
            Divider().background(Color.blue)
         
            Button(action: {
                print("Adding new chore!")
                vm.addNewChore(isCustom: customChore, hasTimeLimit: hasTimeLimit)
                
                presentatioMode.wrappedValue.dismiss()

            }) {
                Text("Add chore")
                    .padding()
                    .frame(width: 180.0, height: 45.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .cornerRadius(10)
                }
        }.onAppear {
            print("Weekday: \(weekDay)")
            vm.setDay(activeDay: weekDay!)
        }
    }
      
    }


struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.container.viewContext
        
        AddChoreView(weekDay: "Monday")
    }
}
