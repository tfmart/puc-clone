//
//  AVACollectionViewCell.swift
//  PUC Clone
//
//  Created by Tomas Martins on 16/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class AVACollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avaAreaTitleLabel: UILabel!
}

extension AVACollectionViewCell {
    func formatAvaTitle() {
        let title = avaAreaTitleLabel.text
        let classCode = String((title?.prefix(5))!)
        if Int(classCode) != nil {
            let codelessTitle = String((title?.dropFirst(7))!)
            avaAreaTitleLabel.text = codelessTitle.formatTitle()
        } else {
            avaAreaTitleLabel.text = title?.formatTitle()
        }
    }
}
