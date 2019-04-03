//
//  ClassDetailViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 18/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    var selectedClass: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentClass = selectedClass {
            headerLabel.text = currentClass.nomeDisciplina?.formatSubjectName()
            courseLabel.text = currentClass.nomeCurso?.formatSubjectName()
            attendanceLabel.text = "\(currentClass.frequencia ?? 0.0)% (\(currentClass.aulasFreq ?? "") de \(currentClass.aulasDadas ?? ""))"
            dateTimeLabel.text = currentClass.horario
            professorLabel.text = currentClass.professor?.formatSubjectName()
            locationButton.setTitle("Sala \(currentClass.sala ?? ""), Prédio \(currentClass.predio?.formatSubjectName() ?? ""), \(currentClass.campus ?? "")", for: .normal)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let mapView = segue.destination as? ClassroomLocationViewController {
                mapView.classToLocate = selectedClass
            }
        }
    }

}
