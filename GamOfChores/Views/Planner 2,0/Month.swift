//
//  Month.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-26.
//

import Foundation
import SwiftUI

class Month: ObservableObject, Identifiable {
    
    init(monthString: String) {
        self.monthString = monthString
    }
    
    let id = UUID()
    var monthString: String
    let chores = [Chore]()
    var weekCount = 0
    
    var firstDay: Date = Date()
    var days = [Date]()
    var daysOfMonth = [Day]()
    
    
    var monthRange: ClosedRange<Date> {
      
        let lastDay = Calendar.current.date(byAdding: .day, value: daysOfMonth.count-1, to: firstDay)!
                
        return firstDay...lastDay
    }
    
    @Published var showWeeks = false {
        willSet {
            objectWillChange.send()
        }
    }
}
