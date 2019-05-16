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
                    self.headerLabel.text = "Você tem \(self.todayClasses.count) aulas hoje"
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
}
