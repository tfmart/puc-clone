//
//  TakenSubjectsTableViewCell.swift
//  PUC Clone
//
//  Created by Tomas Martins on 26/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class TakenSubjectsTableViewCell: UITableViewCell {
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var approvalLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
