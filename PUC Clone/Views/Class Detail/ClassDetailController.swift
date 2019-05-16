//
//  ClassDetailModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController {
    func getLastAttendanceUpdate(date: String) -> String {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        apiDateFormatter.locale = Locale(identifier: "pt_BR")
        let dateFromAPI = apiDateFormatter.date(from: date)
        let attendanceDateFormmater = DateFormatter()
        attendanceDateFormmater.dateFormat = "MMM/y"
        attendanceDateFormmater.locale = Locale(identifier: "pt_BR")
        let attendanceDate = attendanceDateFormmater.string(from: dateFromAPI!)
        return attendanceDate
    }
    
    func setAttendanceLabel() {
        if let attendance = selectedClass?.frequencia {
            if let attendedClasses = selectedClass?.aulasFreq, let totalClasses = selectedClass?.aulasDadas {
                if let lastUpdate = selectedClass?.dataUltimoLancFreq {
                    let attributes = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12)]
                    let lastUpdateString = NSMutableAttributedString(string: " (atualizado em \(self.getLastAttendanceUpdate(date: lastUpdate)))", attributes: attributes)
                    let attendanceString = NSMutableAttributedString(string: "\(attendance)% (\(attendedClasses) de \(totalClasses)))")
                    attendanceString.append(lastUpdateString)
                    attendanceLabel.attributedText = attendanceString
                } else {
                    attendanceLabel.text = "\(attendance)% (\(attendedClasses) de \(totalClasses)))"
                }
            } else {
                attendanceLabel.text = "\(attendance)% de frequencia"
            }
        } else {
            attendanceLabel.text = "Sem dados de frequencia"
        }
    }
}
