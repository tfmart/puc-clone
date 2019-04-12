//
//  DescriptionViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 07/04/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    var classDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.title = "Ementa"
        guard let ementa = classDescription else {
            descriptionTextView.text = "Essa matéria não possui ementa"
            return
        }
        descriptionTextView.text = ementa
    }
}
