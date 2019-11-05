//
//  WeeklyScheduleModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit
import PuccSwift

extension WeeklyScheduleView {
    func setUpButtons(dayString: String) {
        mondayButton.isSelected = false
        tuesdayButton.isSelected = false
        wednesdayButton.isSelected = false
        thrusdayButton.isSelected = false
        fridayButton.isSelected = false
        saturdayButton.isSelected = false
        sundayButton.isSelected = false
        
        switch dayString {
        case "Seg":
            mondayButton.isSelected = true
        case "Ter":
            tuesdayButton.isSelected = true
        case "Qua":
            wednesdayButton.isSelected = true
        case "Qui":
            thrusdayButton.isSelected = true
        case "Sex":
            fridayButton.isSelected = true
        case "Sáb":
            saturdayButton.isSelected = true
        case "Dom":
            sundayButton.isSelected = true
        default: break
        }
    }
    
    func todaysSchedule(subjects: [Subject], weekString: String) -> [Subject] {
        var todaySubjects = [Subject]()
        for subject in subjects {
            switch weekString {
            case "Seg":
                if subject.dayWeek == 2 {
                    todaySubjects.append(subject)
                }
            case "Ter":
                if subject.dayWeek == 3 {
                    todaySubjects.append(subject)
                }
            case "Qua":
                if subject.dayWeek == 4 {
                    todaySubjects.append(subject)
                }
            case "Qui":
                if subject.dayWeek == 5 {
                    todaySubjects.append(subject)
                }
            case "Sex":
                if subject.dayWeek == 6 {
                    todaySubjects.append(subject)
                }
            case "Sáb":
                if subject.dayWeek == 7 {
                    todaySubjects.append(subject)
                }
            case "Dom":
                if subject.dayWeek == 1 {
                    todaySubjects.append(subject)
                }
            default: break
            }
        }
        if self.todayClasses.count == 0 {
            self.noClassView.alpha = 1
        } else {
            self.noClassView.alpha = 0
        }
        return todaySubjects
    }
    
    func configureTableViewAccesibility(model: WeeklyScheduleTableViewCell, currentClass: Subject) {
        self.scheduleTableView.isAccessibilityElement = false
        self.scheduleTableView.shouldGroupAccessibilityChildren = true
        model.titleLabel.isAccessibilityElement = false
        model.scheduleLabel.isAccessibilityElement = false
        model.professorLabel.isAccessibilityElement = false
        model.classroomLabel.isAccessibilityElement = false
        model.attendanceLabel.isAccessibilityElement = false
        model.attendanceIcon.isAccessibilityElement = false
        model.isAccessibilityElement = true
        
        var className: String
        var classAttendance: String
        var description: String
        var building: String
        
        if currentClass.name!.hasPrefix("PF") {
            className = (currentClass.name?.replacingOccurrences(of: "PF-", with: "Prática de Formação: "))!
        } else {
            className = currentClass.name!
        }
        
        if let attendance = currentClass.attendance {
            classAttendance = "\(attendance)"
        } else {
            classAttendance = "Sem dados de frequência."
        }
        
        if (currentClass.building?.hasPrefix("Cent. Tecn"))! {
            building = "Centro Técnico"
        } else {
            building = currentClass.building!
        }
        
        description = "\(className), das \(currentClass.time ?? ""), no prédio \(building), sala \(currentClass.room ?? ""). \(classAttendance)"
        model.accessibilityLabel = description
    }
    
    func configureWeekButtonsAccesibility() {
        self.mondayButton.accessibilityLabel = "Segunda-Feira"
        self.tuesdayButton.accessibilityLabel = "Terça-Feira"
        self.wednesdayButton.accessibilityLabel = "Quarta-Feira"
        self.thrusdayButton.accessibilityLabel = "Quinta-Feira"
        self.fridayButton.accessibilityLabel = "Sexta-Feira"
        self.saturdayButton.accessibilityLabel = "Sábado"
        self.sundayButton.accessibilityLabel = "Domingo"
    }
}
