//
//  WeekDaysRow.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-27.
//

import SwiftUI

struct WeekDaysRow: View {
    
    @Binding var dayIndex: Int
    
    @State private var selection = [0, 1, 2, 3, 4, 5, 6]

    
    var body: some View {
        
        VStack(alignment: .center) {
            
            
            HStack(alignment: .center){
                Button(action: { dayIndex = 0
                        print("Monday")
                        selection = [0]
                }) {
                    Text("Mo").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
               
                Button(action: { dayIndex = 1
                        print("Tuesday") }) {
                    Text(" Tu ").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
            
                Button(action: { dayIndex = 2
                        print("Wednesday") }) {
                    Text(" We ").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
               
                Button(action: { dayIndex = 3
                        print("Thursday") }) {
                    Text(" Th ").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
               
                Button(action: { dayIndex = 4
                        print("Friday") }) {
                    Text(" Fr ").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
            
                Button(action: { dayIndex = 5
                        print("Saturday") }) {
                    Text(" Sa ").font(.system(size: 15.0, weight: .bold))
                }.buttonStyle(GrowingButton())
           
                Button(action: { dayIndex = 6
                        print("Sunday") }) {
                    Text(" Su ").font(.system(size: 15.0, weight: .bold))
                        }.buttonStyle(GrowingButton())
            }
            .padding(.bottom)
        }
    }
}

struct GrowingButton: ButtonStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(9)
            .background( Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

