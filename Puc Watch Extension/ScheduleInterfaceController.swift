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
    override func awake(withContext context: Any?) {
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate() 
    }

}
