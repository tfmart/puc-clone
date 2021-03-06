//
//  TodayView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit
import PuccSwift

class TodayView: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var todayClassesCollectionView: UICollectionView!
    @IBOutlet weak var avaCollectionView: UICollectionView!
    @IBOutlet weak var amountOfClassesLabel: UILabel!
    @IBOutlet weak var noClassMessageView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var completeScheduleButton: UIButton!
    
    //MARK: - Vars
    let currentDate = Date()
    var todayClasses = [Subject]()
    var allClasses = [Subject]()
    var hisotry = [CompletedSubjects]()
    var pucController = PucController()
    var configuration: PucConfiguration?
    var avaTitles: AvaSite?
    var student: Student?
    var token: String?
    var routeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pucController.getSakaiSessionToken(callback: {(token) -> Void in
            DispatchQueue.main.async {
                UserDefaults.standard.set(token, forKey: "sakai")
                self.pucController.getAvaTitles(callback: {(titles) -> Void in
                    DispatchQueue.main.async {
                        self.avaTitles = titles
                        self.avaCollectionView.reloadData()
                    }
                })
            }
        })
        
        self.headerLabel.text = ""
        self.styleNoClassView()
        self.styleScheduleButton()
        super.navigationItem.title = currentDate.scheduleDateTitle()
//        #if DEBUG
//        self.getDemoClasses()
//        #else
        self.getTodayClasses()
        self.getCompletedSubjects()
//        #endif
        self.todayClassesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFromHome" {
            if let classDetailView = segue.destination as? ClassDetailViewController {
                let selectedCells = todayClassesCollectionView.indexPathsForSelectedItems! as NSArray
                let index: IndexPath = selectedCells[0] as! IndexPath
                classDetailView.selectedClass = todayClasses[index.row]
            }
        }
        if segue.identifier == "locationFromToday"{
            if let mapView = segue.destination as? ClassroomLocationViewController {
                mapView.classToLocate = todayClasses[routeIndex ?? 0]
            }
        }
        if segue.identifier == "weekSchedule" {
            if let weekView = segue.destination as? WeeklyScheduleView {
                weekView.allClasses = self.allClasses
            }
        }
        if segue.identifier == "completedSubjects" {
            if let historyView = segue.destination as? HistoryTableViewController {
                historyView.classes = self.hisotry
            }
        }
        if segue.identifier == "studentSegue" {
            if let studentView = segue.destination as? StudentView {
                studentView.student = self.student
            }
        }
    }

}

extension TodayView:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.todayClassesCollectionView {
            return todayClasses.count
        } else {
            if let titles = avaTitles?.siteCollection {
                return titles.count
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.todayClassesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayClass", for: indexPath) as! TodaysClassesCollectionViewCell
            cell.titleLabel.text = todayClasses[indexPath.row].name?.formatTitle()
            cell.scheduleLabel.text = todayClasses[indexPath.row].time
            cell.professorLabel.text = todayClasses[indexPath.row].professor?.formatTitle()
            cell.classroomLabel.text = "\(todayClasses[indexPath.row].building?.formatTitle() ?? "") | Sala \(todayClasses[indexPath.row].room ?? "")"
            
            cell.routeButton.tag = indexPath.row
            if pucController.setAttendanceIcon(attendance: todayClasses[indexPath.row].attendance ?? 0.0) {
                cell.attendanceIcon.image = UIImage(named: "Good")
                cell.attendanceIcon.tintColor = UIColor(named: "Good Attendance")
            } else {
//                cell.attendanceIcon.image = UIImage(named: "Bad Attendance")
                cell.attendanceIcon.image = UIImage(named: "Bad")
                cell.attendanceIcon.tintColor = UIColor(named: "Bad Attendance")
            }
            
            if let attendance = todayClasses[indexPath.row].attendance {
                cell.attendanceLabel.text = "\(attendance)% de presença"
            } else {
                cell.attendanceLabel.text = "Sem dados de presença"
                cell.attendanceIcon.image = UIImage(named: "No Attendance Info")
                cell.attendanceIcon.tintColor = UIColor(named: "Gray Icon")
            }
            
            cell.styleTodayViewCell()
            configure(cellWithModel: cell, currentClass: todayClasses[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ava", for: indexPath) as! AVACollectionViewCell
            //Adding info to cell
            if let titles = avaTitles?.siteCollection {
                cell.avaAreaTitleLabel.text = titles[indexPath.row].title
            }
            //Stylying the cell
            cell.styleTodayViewCell()
            cell.formatAvaTitle()
            
            return cell
        }
    }
}
