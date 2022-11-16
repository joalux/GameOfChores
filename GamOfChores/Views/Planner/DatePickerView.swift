//
//  DatePickerView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-07-21.
//

import SwiftUI

struct DatePickerView: View {
   // @Binding var currentDate: Date
    
   // @Binding var currentMonth: Date
   // @Binding var currentMonth: String
    
    @Binding var monthIndex: Int
    
    @State private var selection = 0
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    
    var body: some View {

        VStack{
            Button {
                print("MONTH!!")
            } label: {
                Text("MONTH")
            }.frame(width: 50, height: 50, alignment: .center)
                .background(.blue)
                .foregroundColor(.white)

            /*
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("2021")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(months[monthIndex])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                
                Button(action: { monthIndex += 1
                        print("week +1") }) {
                    Text("<month").font(.system(size: 15.0, weight: .bold))
                        }.background(.blue)
                    .foregroundColor(.white)
                    .padding()
               Button(action: {
                    print("Changing month")
                }) {
                    Text("<")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Button(action: {
                    print("Changing month")
                }) {
                    Text(">")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding()*/
      
        }.frame(width: 100, height: 100, alignment: .leading)
        
    }
}

