//
//  WeeklyScheduleView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 18/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class WeeklyScheduleView: UIViewController {
    
    var allClasses = [Schedule]()
    var todayClasses = [Schedule]()
    let currentDate =  Date()
    let studentModel = StudentModel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWeeklySchedule()
        self.noClassView.alpha = 0
        if let dayOfTheWeek = currentDate.getDayOfTheWeek() {
            dayWeek = dayOfTheWeek
            self.setUpButtons(dayString: dayOfTheWeek)
        }
        scheduleTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dayWeekButtonPressed(_ sender: UIButton) {
        setUpButtons(dayString: sender.currentTitle!)
        dayWeek = sender.currentTitle!
        scheduleTableView.reloadData()
    }
    
}

extension WeeklyScheduleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todayClasses = self.actualClassesToday(subjects: allClasses, weekString: dayWeek)
        return todayClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullSchedule", for: indexPath) as! WeeklyScheduleTableViewCell
        todayClasses = self.actualClassesToday(subjects: allClasses, weekString: dayWeek)
        cell.titleLabel.text = todayClasses[indexPath.row].nomeDisciplina?.formatSubjectName()
        cell.scheduleLabel.text = todayClasses[indexPath.row].horario
        cell.professorLabel.text = todayClasses[indexPath.row].professor?.formatSubjectName()
        cell.classroomLabel.text = "\(todayClasses[indexPath.row].predio?.formatSubjectName() ?? "") | Sala \(todayClasses[indexPath.row].sala ?? "")"
        cell.attendancelabel.text = "\(todayClasses[indexPath.row].frequencia ?? 0.0)% de presença"
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
