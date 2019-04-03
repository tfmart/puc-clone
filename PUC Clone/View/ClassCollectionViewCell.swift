//
//  ClassCollectionViewCell.swift
//  PUC Clone
//
//  Created by Tomas Martins on 01/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var attendanceCircularBar: CircularProgressBar!
}
