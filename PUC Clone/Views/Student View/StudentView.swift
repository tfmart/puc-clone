//
//  StudentView.swift
//  PUC Clone
//
//  Created by Tomas Martins on 22/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class StudentView: UIViewController {
    
    var student: Student?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let student = student {
            nameLabel.text = student.nome
            courseNameLabel.text = student.curso?.nome
            periodLabel.text = student.curso?.turno
        } else {
            nameLabel.text = "Nenhum aluno encontrado"
        }
    }
    

    

}
