//
//  WeeklyScheduleModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

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
    
    func todaysSchedule(subjects: [Schedule], weekString: String) -> [Schedule] {
        var todaySubjects = [Schedule]()
        for subject in subjects {
            switch weekString {
            case "Seg":
                if subject.diaSemana == 2 {
                    todaySubjects.append(subject)
                }
            case "Ter":
                if subject.diaSemana == 3 {
                    todaySubjects.append(subject)
                }
            case "Qua":
                if subject.diaSemana == 4 {
                    todaySubjects.append(subject)
                }
            case "Qui":
                if subject.diaSemana == 5 {
                    todaySubjects.append(subject)
                }
            case "Sex":
                if subject.diaSemana == 6 {
                    todaySubjects.append(subject)
                }
            case "Sáb":
                if subject.diaSemana == 7 {
                    todaySubjects.append(subject)
                }
            case "Dom":
                if subject.diaSemana == 1 {
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
    
    func configureTableViewAccesibility(model: WeeklyScheduleTableViewCell, currentClass: Schedule) {
        var building: String
        if (currentClass.predio?.hasPrefix("Cent. Tecn"))! {
            building = "Centro Técnico"
        } else {
            building = currentClass.predio!
        }
        self.scheduleTableView.isAccessibilityElement = false
        self.scheduleTableView.shouldGroupAccessibilityChildren = true
        model.titleLabel.isAccessibilityElement = false
        model.scheduleLabel.isAccessibilityElement = false
        model.professorLabel.isAccessibilityElement = false
        model.classroomLabel.isAccessibilityElement = false
        model.attendanceLabel.isAccessibilityElement = false
        model.attendanceIcon.isAccessibilityElement = false
        model.isAccessibilityElement = true
        
        if let attendance = currentClass.frequencia {
            if (currentClass.nomeDisciplina!.hasPrefix("PF")) {
                let classTitle = currentClass.nomeDisciplina?.replacingOccurrences(of: "Pf-", with: "Prática de Formação: ")
                model.accessibilityLabel = "\(classTitle ?? ""), às \(currentClass.horario ?? ""), no prédio \(building), sala \(currentClass.sala ?? ""). Você possui \(attendance)% de presença nesta matéria"
            } else {
                model.accessibilityLabel = "\(currentClass.nomeDisciplina ?? ""), às \(currentClass.horario ?? ""), no prédio \(building), sala \(currentClass.sala ?? ""). Você possui \(attendance)% de presença nesta matéria"
            }
        } else {
            model.accessibilityLabel = "\(currentClass.nomeDisciplina ?? ""), às \(currentClass.horario ?? ""), no prédio \(building), sala \(currentClass.sala ?? ""). Sem dados de presença."
        }

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
