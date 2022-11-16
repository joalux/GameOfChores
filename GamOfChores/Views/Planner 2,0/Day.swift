//
//  Day.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-26.
//

import Foundation
import SwiftUI


class Day: ObservableObject, Identifiable {
    let id = UUID()
    var dayIndex: Int
    var weekNumber: Int
    var weekDayNumber: Int

    var dayString: String
    var date: Date
    var chores: [Chore]
    
    init(day: Date) {
        self.dayIndex = day.get(.day)
        self.weekNumber = day.get(.weekOfMonth)
        self.weekDayNumber = day.get(.weekday)
        self.dayString = ""
        self.date = day
        self.chores = [Chore]()
        print("DAY INIT: \(dayIndex) \(date) weekday: \(weekDayNumber)")
    }
}
