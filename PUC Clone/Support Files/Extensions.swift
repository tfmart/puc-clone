//
//  Extensions.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    //Formats Title for ScheduleView
    func scheduleDateTitle() -> String?{
        let firstFormatter = DateFormatter()
        firstFormatter.dateFormat = "EEE, dd"
        firstFormatter.locale = Locale(identifier: "pt_BR")
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "MMMM"
        secondFormatter.locale = Locale(identifier: "pt_BR")
        let dateTitle = "\(firstFormatter.string(from: self).capitalized) de \(secondFormatter.string(from: self))"
        return dateTitle
    }
    
    //Get a shorter day of the week string
    func getDayOfTheWeek() -> String? {
        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "EEE"
        weekFormatter.locale = Locale(identifier: "pt_BR")
        let dayString = "\(weekFormatter.string(from: self).capitalized)"
        return dayString
    }
}

extension String {
    //Formats the strings for the headers
    func formatYear() -> String {
        let semester = String(self.last!)
        let year = String(self.prefix(4))
        let result = "\(year) (\(semester)º Semestre)"
        return result
    }
    
    //Format the taken subject name
    func formatTitle() -> String {
        let capitalizedString = self.capitalized
        var formattedString = capitalizedString.replacingOccurrences(of: " E ", with: " e ")
        formattedString = formattedString.replacingOccurrences(of: " À ", with: " à ")
        formattedString = formattedString.replacingOccurrences(of: " Do ", with: " do ")
        formattedString = formattedString.replacingOccurrences(of: " Dos ", with: " dos ")
        formattedString = formattedString.replacingOccurrences(of: " De ", with: " de ")
        formattedString = formattedString.replacingOccurrences(of: " Da ", with: " da ")
        formattedString = formattedString.replacingOccurrences(of: " Das ", with: " das ")
        formattedString = formattedString.replacingOccurrences(of: " Na ", with: " na ")
        formattedString = formattedString.replacingOccurrences(of: " No ", with: " no ")
        formattedString = formattedString.replacingOccurrences(of: " Pf- ", with: " PF - ")
        return formattedString
    }
}

//MARK: Extension for array of String
extension Sequence where Iterator.Element == String {
    func getYearsForHeader(classes: [CompletedSubjects]) -> [String] {
        var years = [String]()
        for subject in classes {
            if years.contains(subject.aass?.formatYear() ?? "") == false {
                if let yearToFormat = subject.aass {
                    years.append(yearToFormat.formatYear())
                }
            }
        }
        return years
    }
}

//MARK: Extension for array of CompletedTableCell
extension Sequence where Iterator.Element == CompletedTableCell {
    func formatSubjectsForTable(subjects: [CompletedSubjects]) -> [CompletedTableCell] {
        var formatedData = [CompletedTableCell]()
        var subjectsPerYear = [BasicSubject]()
        var previousYear = String()
        
        if subjects.isEmpty == false {
            if let firstYear = subjects[0].aass {
                previousYear = firstYear
                for subject in subjects {
                    guard let year = subject.aass, let name = subject.nome, let acceptance = subject.decSitcli, let grade = subject.media, let code = subject.codigo, let hours = subject.cargaHoraria else {
                        return formatedData
                    }
                    if subjectsPerYear.isEmpty == false  && previousYear != year{
                        formatedData.append(CompletedTableCell(yearSection: previousYear, subjects: subjectsPerYear))
                        subjectsPerYear = []
                        previousYear = year
                    } else {
                        subjectsPerYear.append(BasicSubject(name: name, grade: grade, acceptance: acceptance, code: code, hours: hours))
                    }
                }
                formatedData.append(CompletedTableCell(yearSection: subjects.last?.aass, subjects: subjectsPerYear))
            }
        } else {
            //no subjects were found
        }
        return formatedData
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0),
        alpha: Float = 1,
        x: CGFloat = 0,
        y: CGFloat = 4,
        blur: CGFloat = 16,
        spread: CGFloat = -7)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
