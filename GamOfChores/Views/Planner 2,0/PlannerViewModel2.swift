//
//  PlannerView2ViewModel.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-19.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreData

@MainActor
class PlannerViewModel2: ObservableObject {
    
    let dateFormatter = DateFormatter()
    
    @Published var listHeight = 0.0
        
    @Published var months = [Month(monthString: "January"), Month(monthString: "February"), Month(monthString: "March"), Month(monthString: "April"), Month(monthString: "May"), Month(monthString: "June"), Month(monthString: "July"), Month(monthString: "August"), Month(monthString: "September"), Month(monthString: "October"), Month(monthString: "November"), Month(monthString: "December")]
    
    let cal = Calendar.current
    
    init() {
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale.current
        getFirstMonth()
    }
        
    func getFirstMonth() {
        print("_____SETTING MONTH_________")
        let currentDate = Date()
        let comps = cal.dateComponents([.month, .day], from: currentDate)
        
        var monthComponent = DateComponents()
        var dayComponent = DateComponents()

        var monthIndex = 0
        var dayIndex = 0
        
        if let currentIndex = comps.month {
            monthIndex = currentIndex - 1
        }
        monthComponent.month = -monthIndex
        
        if let currentIndex = comps.day {
            dayIndex = currentIndex - 1
        }
        dayComponent.day = -dayIndex
        
        var firstMonth = Calendar.current.date(byAdding: monthComponent, to: currentDate)
        firstMonth = Calendar.current.date(byAdding: dayComponent, to: firstMonth!)
        
        setMonths(firstMonth: firstMonth!)
        
    }
    
    func setMonths(firstMonth: Date) {
        var firstOfMonth = firstMonth
        for month in months {
            print("Setting = ", month.monthString)
            month.firstDay = firstOfMonth
            
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
            firstOfMonth = Calendar.current.date(byAdding: dateComponent, to: firstOfMonth)!
            
            print("First day = ", month.firstDay)
            
            setDays(month: month)
        }
    }
    
    func setDays(month: Month) {
        print("Setting days of month")
        print("First day = ", month.firstDay)
        var day = Day(day: month.firstDay)
        print("Current =", day.date)
        
        print("--------")
                
        let monthRange = cal.range(of: .day, in: .month, for: day.date)!

        var daysOfMonth = [Day]()
        
        daysOfMonth.append(day)
        
        for i in monthRange {
            var date = Calendar.current.date(byAdding: .day, value: i, to: day.date)!

            var newDay = Day(day: date)

            daysOfMonth.append(newDay)
        }
        
        daysOfMonth.removeLast()
        
        print("Got days = ", daysOfMonth.count)
        for day in daysOfMonth {
            month.daysOfMonth.append(day)
            print("Day = ", day.date)
            let week = cal.dateComponents([.weekOfMonth], from: day.date)
            print("Week = ", week)
        }
        month.weekCount = cal.dateComponents([.weekOfMonth], from: daysOfMonth.last!.date).weekOfMonth!
        print(month.weekCount)
        print(month.monthString, " is set!")
    }
  
}

