//
//  TodayModel.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

extension TodayView {
    func getDayOfWeek() -> Int {
        var day = 0
        let currentDate = Date()
        let dayString = currentDate.getDayOfTheWeek()
        switch dayString {
        case "Seg":
            day = 2
        case "Ter":
            day = 3
        case "Qua":
            day = 4
        case "Qui":
            day = 5
        case "Sex":
            day = 6
        case "Sáb":
            day = 7
        case "Dom":
            day = 1
        default: break
        }
        return day
    }
    
    func getTodayClasses() {
        let today = self.getDayOfWeek()
        pucController.getWeekSchedule(callback: {(weeklySchedule) -> Void in
            DispatchQueue.main.async {
                self.allClasses = weeklySchedule
                for schedule in weeklySchedule {
                    if schedule.diaSemana == today {
                        self.todayClasses.append(schedule)
                    }
                }
                self.todayClassesCollectionView.reloadData()
                if self.todayClasses.count == 0 {
                    self.noClassMessageView.alpha = 1
                    self.todayClassesCollectionView.alpha = 0
                    self.headerLabel.text = "Você não tem aula hoje"
                } else {
                    self.noClassMessageView.alpha = 0
                    self.todayClassesCollectionView.alpha = 1
                    if self.todayClasses.count > 1 {
                        self.headerLabel.text = "Você tem \(self.todayClasses.count) aulas hoje"
                    } else {
                        self.headerLabel.text = "Você tem \(self.todayClasses.count) aula hoje"
                    }
                }
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func getCompletedSubjects() {
        pucController.getTakenClasses(callback: {(takenClasses) -> Void in
            DispatchQueue.main.async {
                self.hisotry = takenClasses
            }
        })
    }
    
    final func configure(cellWithModel model: TodaysClassesCollectionViewCell, currentClass: Schedule) {
        self.todayClassesCollectionView.isAccessibilityElement = false
        self.todayClassesCollectionView.shouldGroupAccessibilityChildren = true
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
        
        if currentClass.nomeDisciplina!.hasPrefix("PF") {
            className = (currentClass.nomeDisciplina?.replacingOccurrences(of: "PF-", with: "Prática de Formação: "))!
        } else {
            className = currentClass.nomeDisciplina!
        }
        
        if let attendance = currentClass.frequencia {
            classAttendance = "\(attendance)"
        } else {
            classAttendance = "Sem dados de frequência."
        }
        
        if (currentClass.predio?.hasPrefix("Cent. Tecn"))! {
            building = "Centro Técnico"
        } else {
            building = currentClass.predio!
        }
        
        description = "\(className), das \(currentClass.horario ?? ""), no prédio \(building), sala \(currentClass.sala ?? ""). \(classAttendance)"
        model.accessibilityLabel = description
    }
}
