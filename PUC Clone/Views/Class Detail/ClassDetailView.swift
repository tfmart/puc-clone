//
//  ClassDetailViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 18/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit
import PuccSwift

class ClassDetailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    var selectedClass: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentClass = selectedClass {
            self.setAttendanceLabel()
            headerLabel.text = currentClass.name?.formatTitle()
            courseLabel.text = currentClass.courseName?.formatTitle()
            dateTimeLabel.text = currentClass.time
            professorLabel.text = currentClass.professor?.formatTitle()
            locationButton.setTitle("Sala \(currentClass.room ?? ""), Prédio \(currentClass.building?.formatTitle() ?? ""), \(currentClass.campus ?? "")", for: .normal)
            codeLabel.text = currentClass.code
            classLabel.text = currentClass.classroom
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let mapView = segue.destination as? ClassroomLocationViewController {
                mapView.classToLocate = selectedClass
            }
        }
        if segue.identifier == "description" {
            if let descriptionView = segue.destination as? DescriptionViewController {
                descriptionView.classDescription = selectedClass?.description
            }
        }
    }
    
    @IBAction func descriptionButtonPreseed(_ sender: Any) {
        performSegue(withIdentifier: "description", sender: nil)
    }
    
}
