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
    var pucController = PucController()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    //https://gateway-publico.pucapi.puc-campinas.edu.br/mobile/v3/alunos/autenticado
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        pucController.initialLogin { (student) in
            DispatchQueue.main.async {
                self.nameLabel.text = student.nome
                self.courseNameLabel.text = student.curso?.nome
                self.periodLabel.text = student.periodo
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func studentError() {
        nameLabel.text = "Nenhum aluno encontrado"
    }
}
