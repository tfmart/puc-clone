//
//  TodayView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class TodayView: UIViewController {
    
    enum Week: Int {
        case sunday = 1, monday, tuesday, wednesday, thrusday, friday
    }

    //Mark: @IBOutlets
    @IBOutlet weak var todayClassesCollectionView: UICollectionView!
    @IBOutlet weak var avaCollectionView: UICollectionView!
    @IBOutlet weak var amountOfClassesLabel: UILabel!
    @IBOutlet weak var noClassMessageView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var completeScheduleButton: UIButton!
    //Mark: Vars
    let currentDate = Date()
    var todayClasses = [Schedule]()
    var allClasses = [Schedule]()
    var studentModel = StudentModel()
    var avaTitles: AvaSite?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentModel.getSakaiSessionToken(callback: {(token) -> Void in
            DispatchQueue.main.async {
                self.token = token
                self.studentModel.getAvaTitles(token: token, callback: {(titles) -> Void in
                    DispatchQueue.main.async {
                        //dump(titles)
                        self.avaTitles = titles
                        self.avaCollectionView.reloadData()
                    }
                })
            }
        })
        
        //Style button
        completeScheduleButton.layer.cornerRadius = 8.0
        completeScheduleButton.layer.borderWidth = 1.0
        completeScheduleButton.backgroundColor = UIColor.white
        completeScheduleButton.layer.masksToBounds = true
        completeScheduleButton.layer.borderColor = UIColor.clear.cgColor
        completeScheduleButton.layer.shadowPath = UIBezierPath(roundedRect:completeScheduleButton.bounds, cornerRadius:completeScheduleButton.layer.cornerRadius).cgPath
        completeScheduleButton.layer.masksToBounds = false
        
        //Style No Classes View
        noClassMessageView.layer.cornerRadius = 8.0
        noClassMessageView.layer.borderWidth = 1.0
        noClassMessageView.backgroundColor = UIColor.white
        noClassMessageView.layer.masksToBounds = true
        noClassMessageView.layer.borderColor = UIColor.clear.cgColor
        noClassMessageView.layer.shadowPath = UIBezierPath(roundedRect:noClassMessageView.bounds, cornerRadius:noClassMessageView.layer.cornerRadius).cgPath
        noClassMessageView.layer.masksToBounds = false
        
        self.headerLabel.text = ""
        super.navigationItem.title = currentDate.scheduleDateTitle()
        self.getTodayClasses()
        self.todayClassesCollectionView.reloadData()
        // Do any additional setup after loading the view.
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
            //Adding info to cell
            cell.classTitle.text = todayClasses[indexPath.row].nomeDisciplina?.formatSubjectName()
            cell.scheduleLabel.text = todayClasses[indexPath.row].horario
            cell.professorLabel.text = todayClasses[indexPath.row].professor?.formatSubjectName()
            cell.classroomLabel.text = "\(todayClasses[indexPath.row].predio?.formatSubjectName() ?? "") | Sala \(todayClasses[indexPath.row].sala ?? "")"
            cell.attendanceLabel.text = "\(todayClasses[indexPath.row].frequencia ?? 0.0)% de presença"
            //Stylying the cell
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            cell.layer.applySketchShadow()
            cell.layer.masksToBounds = false
            //Route button
            if todayClasses[indexPath.row].latitude == nil && todayClasses[indexPath.row].longitude == nil {
                cell.routeButton.isEnabled = false
                cell.routeButton.alpha = 0
            } else {
                cell.routeButton.isEnabled = true
                cell.routeButton.alpha = 1
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ava", for: indexPath) as! AVACollectionViewCell
            //Adding info to cell
            if let titles = avaTitles?.siteCollection {
                cell.avaAreaTitleLabel.text = titles[indexPath.row].title
            }
            //Stylying the cell
            cell.contentView.layer.cornerRadius = 8.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            cell.layer.applySketchShadow()
            cell.layer.masksToBounds = false
            return cell
        }
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
                let idx1 = todayClassesCollectionView.indexPathsForSelectedItems! as NSArray
                let idx2: IndexPath = idx1[0] as! IndexPath
                mapView.classToLocate = todayClasses[idx2.row]
            }
        }
    }
}
