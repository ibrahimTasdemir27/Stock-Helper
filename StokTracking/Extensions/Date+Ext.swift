//
//  Date+Ext.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 4.01.2023.
//

import Foundation


extension Date {
    
    static func getGmt(from: TimeZone, to: TimeZone = TimeZone.current) -> Date {
        let sourceOffset = from.secondsFromGMT(for: self.now)
        let destinationOffset = to.secondsFromGMT(for: self.now)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
        return Date(timeInterval: timeInterval, since: self.now)
    }
    
    //MARK: -> This Month
    
    mutating func addDay(_ n: Int) {
        let calendar = Calendar.current
        self = calendar.date(byAdding: .day, value: n, to: self)!
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        return calendar
    }
    
    func firstOfDayMonth() -> Date {
        print("FirstDay",firstOfDayWeek())
        return calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!.addingTimeInterval(TimeInterval(60*60*24))
    }
    
    func firstOfDayWeek() -> Date {
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        comps.weekday = 2
        let monday = calendar.date(from: comps)
        return monday!
    }
    
    func getMonthAllDays() -> [Date] {
        var days = [Date]()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        var day = firstOfDayMonth()
        for _ in 1...range.upperBound - 1 {
            days.append(day)
            day.addDay(1)
        }
        return days
    }
    
    //MARK: -> This Week
    
    func getWeek() -> [Date] {
        var days = [Date]()
        var isMonday = firstOfDayWeek()
        let range = calendar.range(of: .day, in: .weekOfMonth, for: isMonday)!
        for _ in range.lowerBound..<range.upperBound {
            days.append(isMonday)
            isMonday = isMonday.addingTimeInterval(60*60*24)
        }
        return days
    }
    
    
    
}
