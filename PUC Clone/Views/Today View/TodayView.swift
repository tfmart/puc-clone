//
//  TodayView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

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
    var todayClasses = [Schedule]()
    var allClasses = [Schedule]()
    var hisotry = [CompletedSubjects]()
    var pucController = PucController()
    var avaTitles: AvaSite?
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
        self.getTodayClasses()
        self.getCompletedSubjects()
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
            cell.classTitle.text = todayClasses[indexPath.row].nomeDisciplina?.formatTitle()
            cell.scheduleLabel.text = todayClasses[indexPath.row].horario
            cell.professorLabel.text = todayClasses[indexPath.row].professor?.formatTitle()
            cell.classroomLabel.text = "\(todayClasses[indexPath.row].predio?.formatTitle() ?? "") | Sala \(todayClasses[indexPath.row].sala ?? "")"
            if let frequencia = todayClasses[indexPath.row].frequencia {
                cell.attendanceLabel.text = "\(frequencia)% de presença"
            } else {
                cell.attendanceLabel.text = "Sem dados de presença"
                cell.attendanceIcon.image = UIImage(named: "No Attendance Info")
            }
            
            cell.routeButton.tag = indexPath.row
            if pucController.setAttendanceIcon(attendance: todayClasses[indexPath.row].frequencia ?? 0.0) {
                cell.attendanceIcon.image = UIImage(named: "Good Attendance")
            } else {
                cell.attendanceIcon.image = UIImage(named: "Bad Attendance")
            }
            cell.styleTodayViewCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ava", for: indexPath) as! AVACollectionViewCell
            //Adding info to cell
            if let titles = avaTitles?.siteCollection {
                cell.avaAreaTitleLabel.text = titles[indexPath.row].title
            }
            //Stylying the cell
            cell.styleTodayViewCell()
            
            return cell
        }
    }
}
