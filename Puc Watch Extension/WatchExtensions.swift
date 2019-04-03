//
//  WatchExtensions.swift
//  Puc Watch Extension
//
//  Created by Tomas Martins on 27/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

extension Date {
    func getDayOfTheWeek() -> String? {
        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "EEE"
        weekFormatter.locale = Locale(identifier: "pt_BR")
        let dayString = "\(weekFormatter.string(from: self).capitalized)"
        return dayString
    }
}

extension Int {
    func getDayWeekInt() -> Int? {
        let date =  Date()
        let weekString = date.getDayOfTheWeek()
        switch weekString {
        case "Seg":
            return 2
        case "Ter":
            return 3
        case "Qua":
            return 4
        case "Qui":
            return 5
        case "Sex":
            return 6
        case "Sáb":
            return 7
        case "Dom":
            return 1
        default: break
        }
        return 0
    }
}
