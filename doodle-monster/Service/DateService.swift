//
//  DateService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class DateService {
    func getPrettyDiff(_ date1: Date, date2: Date) -> String {
        let seconds = date2.timeIntervalSince(date1)
        
        if (seconds < 0) {
            fatalError("Seconds cannot be less than zero. Did you give pass in the dates in the correct order?")
        }
        
        let oneMinute = TimeInterval(60)
        let oneHour = TimeInterval(oneMinute * 60)
        let oneDay = TimeInterval(oneHour * 24)
        let oneWeek = TimeInterval(oneDay * 7)
        let oneMonth = TimeInterval(oneDay * 30)
        let oneYear = TimeInterval(oneDay * 365)
        
        if seconds < oneMinute {
            return "\(Int(seconds))s"
        } else if seconds < oneHour {
            let minutes = seconds / oneMinute
            return "\(Int(minutes))m"
        } else if seconds < oneDay {
            let hours = round(seconds / oneHour)
            return "\(Int(hours))h"
        } else if seconds < oneWeek {
            let days = seconds / oneDay
            return "\(Int(days))d"
        } else if seconds < oneMonth {
            let weeks = seconds / oneWeek
            return "\(Int(weeks))w"
        } else if seconds < oneYear {
            let months = seconds / oneMonth
            return "\(Int(months))mo"
        } else {
            let years = seconds / oneYear
            return "\(Int(years))y"
        }
    }
}
