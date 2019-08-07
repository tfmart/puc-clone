//
//  WeeklyScheduleView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 18/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit
import PuccSwift

class WeeklyScheduleView: UIViewController {
    
    var allClasses = [Schedule]()
    var todayClasses = [Schedule]()
    let currentDate =  Date()
    let pucController = PucController()
    var dayWeek: String!
    //MARK: @IBOutlets
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thrusdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var noClassView: UIView!
    @IBOutlet weak var attendanceIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWeekButtonsAccesibility()
        self.noClassView.alpha = 0
        if let dayOfTheWeek = currentDate.getDayOfTheWeek() {
            dayWeek = dayOfTheWeek
            self.setUpButtons(dayString: dayOfTheWeek)
            todayClasses = self.todaysSchedule(subjects: allClasses, weekString: dayWeek)
        }
        scheduleTableView.tableFooterView?.backgroundColor = UIColor(named: "Today Background")
        scheduleTableView.reloadData()
    }
    
    @IBAction func dayWeekButtonPressed(_ sender: UIButton) {
        setUpButtons(dayString: sender.currentTitle!)
        dayWeek = sender.currentTitle!
        todayClasses = self.todaysSchedule(subjects: allClasses, weekString: dayWeek)
        scheduleTableView.reloadData()
    }
    
}

extension WeeklyScheduleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todayClasses = self.todaysSchedule(subjects: allClasses, weekString: dayWeek)
        return todayClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullSchedule", for: indexPath) as! WeeklyScheduleTableViewCell
        todayClasses = self.todaysSchedule(subjects: allClasses, weekString: dayWeek)
        cell.titleLabel.text = todayClasses[indexPath.row].nomeDisciplina?.formatTitle()
        cell.scheduleLabel.text = todayClasses[indexPath.row].horario
        cell.professorLabel.text = todayClasses[indexPath.row].professor?.formatTitle()
        cell.classroomLabel.text = "\(todayClasses[indexPath.row].predio?.formatTitle() ?? "") | Sala \(todayClasses[indexPath.row].sala ?? "")"
        if let attendance = todayClasses[indexPath.row].frequencia {
            cell.attendanceLabel.text = "\(attendance)% de presença"
            if pucController.setAttendanceIcon(attendance: attendance) {
                cell.attendanceIcon.image = UIImage(named: "Good")
                cell.attendanceIcon.tintColor = UIColor(named: "Good Attendance")
            } else {
                cell.attendanceIcon.image = UIImage(named: "Bad")
                cell.attendanceIcon.tintColor = UIColor(named: "Bad Attendance")
            }
        } else {
            cell.attendanceLabel.text = "Sem dados de presença"
            cell.attendanceIcon.image = UIImage(named: "No Attendance Info")
            cell.attendanceIcon.tintColor = UIColor(named: "Gray Icon")
        }
        configureTableViewAccesibility(model: cell, currentClass: todayClasses[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "classDetailSegue" {
            if let classDetailView = segue.destination as? ClassDetailViewController {
                let classIndex = scheduleTableView.indexPathForSelectedRow?.row
                classDetailView.selectedClass = todayClasses[classIndex!]
            }
        }
        
    }
    
    
}
