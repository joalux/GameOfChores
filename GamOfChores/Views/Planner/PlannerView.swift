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
    
    @ObservedObject private var vm2 = TodoViewModel()
            
    @State var goAddView = false
    @State var showCalendar = false
    @State var loadTemplate = false
    @State var goCreateTemplate = false
    @State var fromAddView = true
    
    @State var currentIndex: Int = 0
        
    @State var tempChore = Chore()
        
    var body: some View {
   
        VStack {
            
            NavigationLink(destination: AddChoreView(templateMode: false, newTempChore: $tempChore, fromAddView: $fromAddView, dateToDo: vm.selectedDate), isActive: $goAddView) { EmptyView() }

            NavigationLink(destination: TemplateMakerView(), isActive: $goCreateTemplate) { EmptyView() }
            
            if showCalendar {
                DatePicker("Select date", selection: $vm.selectedDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .onReceive([self.vm.selectedDate].publisher.first()) { newDate in
                        print("____new date = \(vm.selectedDate.get(.day))")
                        
                        
                    }
                    
                Button {
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
            
            //View date title
            Text("\(vm.dateFormatter.string(from: vm.selectedDate).capitalizingFirstLetter()) \(vm.selectedDate.get(.day))/\(vm.selectedDate.get(.month))")
                .font(.system(size: 20, weight: .bold, design: .default))
                .padding(.leading)
            /*
            CarouselView(itemHeight: 600, views: [
                AnyView(Text("Hello").background(Color.red)),
                AnyView(DayView(chores: $vm.chores, selectedDate: $vm.selectedDate)),
                AnyView(Text("Godmorning")),
                AnyView(Text("World")),
            
            
            
            ])*/
            //DayCarouselView(currentIndex: $currentIndex)
            
           /* TabView(selection: $vm.selectedDate) {
                
                ForEach(vm.weekDaysFull, id: \.self) { day in
                    DayView(chores: $vm.chores, selectedDate: $vm.selectedDate)
                        .padding(.horizontal, 20)
                        .cornerRadius(10)
                        
                }
            }
            .onChange(of: vm.currentDayIndex, perform: { dayIndex in
                print("_____INDEX = \(dayIndex)")
                //vm.setDay()
        
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))*/
            
            .navigationBarTitle("Planner", displayMode: .inline)
        
            Divider().background(Color.blue)
            
            HStack {
                Button {
                    print("Adding chore")
                    goAddView = true
                } label: {
                    Text("Add chore")
                        .frame(width: 140.0, height: 45.0, alignment: .center)
                        .background(vm.buttonEnabled ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
                .disabled(vm.selectedDate.get(.day) < Date().get(.day))
                
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
                        print("Loading template")
                        vm.showLoadAlert = true
                        
                        
                    } label: {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .frame(width: 45.0, height: 45.0, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    Text("   Load \n template")
                        .lineLimit(2)
                        .font(.subheadline)
                    
                }.alert(isPresented: $vm.showLoadAlert, content: {
                    
                    Alert(title: Text("Load template"), message: Text("Do yoy want to load your template for this week?"),primaryButton: .default(Text(LocalizedStringKey("Yes"))) {
                        vm.getTemplateChores()

                    },secondaryButton: .default(Text(LocalizedStringKey("No"))) {
                        print("NO LOAD...")
                    }
                    )
                })
               
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
            print("----PLANNER APPEAR")
            
            print("___VM DATE ____\(vm.selectedDate.get(.day))")
            print("___VM CURRENT ____\(vm.currentDate.get(.day))")
            print("___DATE ____\(Date().get(.day))")
            vm.fetchChores()
            
        }
    }
    func deleteChore(at offsets: IndexSet) {
        offsets.forEach { index in
            let chore = vm.chores[index]
            
            //$vm.removeChore(chore: chore)
            
        }
        vm.chores.remove(atOffsets: offsets)

    }
}
