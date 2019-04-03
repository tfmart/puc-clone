//
//  ScheduleInterfaceController.swift
//  Puc Watch Extension
//
//  Created by Tomas Martins on 26/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {
    @IBOutlet weak var scheduleTable: WKInterfaceTable!
    var classesTitle: [String]!
    let studentModel =  StudentWatchModel()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        scheduleTable.setNumberOfRows(classesTitle.count, withRowType: "class")
        // Configure interface objects here.
        for index in 0..<scheduleTable.numberOfRows {
            guard let controller = scheduleTable.rowController(at: index) as? ClassRowController else { continue }
            controller.classTitleLabel.setText(classesTitle[index])
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        getTodaySubjects()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getTodaySubjects() {
        studentModel.getTodaysSchedule(callback: {(takenClasses) -> Void in
            DispatchQueue.main.async {
                self.classesTitle = takenClasses
                
            }
        })
    }

}
