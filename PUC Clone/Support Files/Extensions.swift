//
//  Extensions.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

extension Date{
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

extension ClassCollectionViewCell {
    //Fills cell from the ScheduleView
    func fillActualCells(subject: Schedule, dayOfTheWeek: String) {
        if let attendanceNumber = subject.frequencia {
            self.attendanceLabel.text = "\(attendanceNumber)"
        }
        self.subjectLabel.text = subject.nomeDisciplina?.formatSubjectName()
        self.formatActualInfo(subject: subject)
        let attendanceNumber = subject.frequencia!
        self.attendanceCircularBar.safePercent = 75
        self.attendanceCircularBar.setProgress(to: Double(attendanceNumber), withAnimation: true)
        self.styleCell()
    }
    
    //Formats the class information string
    func formatActualInfo(subject: Schedule) {
        let infoString = "\(subject.horario ?? "") | \(subject.predio ?? "") Sala \(subject.sala ?? "")"
        let beginTime = infoString.prefix(5)
        let range = (infoString as NSString).range(of: String(beginTime))
        let attributedInfoString = NSMutableAttributedString(string: infoString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
        attributedInfoString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black], range: range)
        self.infoLabel.attributedText = attributedInfoString
    }
    
    //Style the cell from ScheduleView
    func styleCell() {
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        self.layer.applySketchShadow()
        self.layer.masksToBounds = false
    }
}

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
    
    func getWeeklySchedule() {
        studentModel.getWeekSchedule(callback: {(weeklySchedule) -> Void in
            DispatchQueue.main.async {
                self.allClasses = weeklySchedule
            }
        })
    }
    
    func getScheduleForDay(weekString: String) {
        studentModel.getWeekSchedule(callback: {(weeklySchedule) -> Void in
            DispatchQueue.main.async {
                for schedule in weeklySchedule {
                    switch weekString {
                    case "Seg":
                        if schedule.diaSemana == 2 {
                            self.todayClasses.append(schedule)
                        }
                    case "Ter":
                        if schedule.diaSemana == 3 {
                            self.todayClasses.append(schedule)
                        }
                    case "Qua":
                        if schedule.diaSemana == 4 {
                            self.todayClasses.append(schedule)
                        }
                    case "Qui":
                        if schedule.diaSemana == 5 {
                            self.todayClasses.append(schedule)
                        }
                    case "Sex":
                        if schedule.diaSemana == 6 {
                            self.todayClasses.append(schedule)
                        }
                    case "Sáb":
                        if schedule.diaSemana == 7 {
                            self.todayClasses.append(schedule)
                        }
                    case "Dom":
                        if schedule.diaSemana == 1 {
                            self.todayClasses.append(schedule)
                        }
                    default: break
                    }
                }
            }
            if self.todayClasses.count == 0 {
                self.noClassView.alpha = 1
            } else {
                self.noClassView.alpha = 0
            }
            self.scheduleTableView.reloadData()
        })
    }
    
    func actualClassesToday(subjects: [Schedule], weekString: String) -> [Schedule] {
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
}

extension ScheduleView {
    //Set up the buttons at ScheduleView
    func setUpButtons(dayString: String) {
        mondayButton.isSelected = false
        tuesdayButton.isSelected = false
        wednesdayButton.isSelected = false
        thrusdayButton.isSelected = false
        fridayButton.isSelected = false
        saturdayButton.isSelected = false
        sundayButton.isSelected = false
        weekButtonStackView.layer.applySketchShadow(color: UIColor(red:0.51, green:0.51, blue:0.51, alpha:1.0), alpha: 0.5, x: 0, y: 2, blur: 15, spread: -7)
        
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
    
    func actualClassesToday(subjects: [Schedule], weekString: String) -> [Schedule] {
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
        return todaySubjects
    }
    
    func getWeeklySchedule() {
        studentModel.getWeekSchedule(callback: {(weeklySchedule) -> Void in
            DispatchQueue.main.async {
                self.actualClasses = weeklySchedule
                self.classesCollectionView.reloadData()
            }
        })
    }
}

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
        studentModel.getWeekSchedule(callback: {(weeklySchedule) -> Void in
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
    func formatSubjectName() -> String {
        let capitalizedSubject = self.capitalized
        var formattedString = capitalizedSubject.replacingOccurrences(of: " E ", with: " e ")
        formattedString = formattedString.replacingOccurrences(of: " À ", with: " à ")
        formattedString = formattedString.replacingOccurrences(of: " Do ", with: " do ")
        formattedString = formattedString.replacingOccurrences(of: " Dos ", with: " dos ")
        formattedString = formattedString.replacingOccurrences(of: " De ", with: " de ")
        formattedString = formattedString.replacingOccurrences(of: " Da ", with: " da ")
        formattedString = formattedString.replacingOccurrences(of: " Das ", with: " das ")
        formattedString = formattedString.replacingOccurrences(of: " Na ", with: " na ")
        formattedString = formattedString.replacingOccurrences(of: " No ", with: " no ")
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
                    guard let year = subject.aass else {
                        return formatedData
                    }
                    guard let name = subject.nome else {
                        return formatedData
                    }
                    guard let acceptance = subject.decSitcli else {
                        return formatedData
                    }
                    guard let grade = subject.media else {
                        return formatedData
                    }
                    if subjectsPerYear.isEmpty == false  && previousYear != year{
                        formatedData.append(CompletedTableCell(yearSection: previousYear, subjects: subjectsPerYear))
                        subjectsPerYear = []
                        previousYear = year
                    } else {
                        subjectsPerYear.append(BasicSubject(name: name, grade: grade, acceptance: acceptance))
                    }
                }
                formatedData.append(CompletedTableCell(yearSection: subjects.last?.aass, subjects: subjectsPerYear))
            }
        } else {
            print("subjects is empty")
        }
        return formatedData
    }
}

//Gets taken subjects from the API
extension TakenSubjectsTableViewController {
    func getCompletedSubjects() {
        studentModel.getTakenClasses(callback: {(takenClasses) -> Void in
            DispatchQueue.main.async {
                self.classes = takenClasses
                self.headers = self.headers.getYearsForHeader(classes: self.classes)
                self.formatedData = self.formatedData.formatSubjectsForTable(subjects: self.classes)
                self.tableView.reloadData()
            }
        })
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
