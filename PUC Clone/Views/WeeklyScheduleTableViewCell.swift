//
//  WeeklyScheduleTableViewCell.swift
//  PUC Clone
//
//  Created by Tomas Martins on 18/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class WeeklyScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var classroomLabel: UILabel!
    @IBOutlet weak var attendancelabel: UILabel!
    @IBOutlet weak var attendanceIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
