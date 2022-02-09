//
//  StartMenuView.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-11.
//

import SwiftUI

struct StartMenuView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject var coreManager = CoreDataManager()
        
    @State var goChores = false
    @State var goFamily = false
    @State var goPlanner = false
    @State var goSettings = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: TodoView(), isActive: $goChores) { EmptyView() }
                
               NavigationLink(destination: FamilyView(), isActive: $goFamily) { EmptyView() }

                NavigationLink(destination: PlannerView(), isActive: $goPlanner) { EmptyView() }

        
                Button(action: {
                    goChores = true
                }, label: {
                   Text("Chores")
                       .padding()
                       .frame(width: 220.0, height: 55.0)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .font(.headline)
                       .cornerRadius(10)
               }).padding(.bottom)
                   
               Button(action: {
                   goFamily = true
                    
               }, label: {
                    Text("My family")
                       .padding()
                       .frame(width: 220.0, height: 55.0)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .font(.headline)
                       .cornerRadius(10)
               }).padding(.bottom)
               

                
               Button(action: {
                   goPlanner = true
                  
               }, label: {
                   Text("Planner")
                       .padding()
                       .frame(width: 220.0, height: 55.0)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .font(.headline)
                       .cornerRadius(10)
               }).padding(.bottom)
                   
                Button(action: {
                    goSettings = true
                }, label: {
                    Text("Settings")
                        .padding()
                        .frame(width: 190.0, height: 45.0)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .cornerRadius(10)
                }).padding(.bottom)
            }
        }.navigationBarHidden(true)
           
    }
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}
