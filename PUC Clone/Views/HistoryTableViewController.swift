//
//  HistoryTableViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 03/04/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    let pucController = PucController()
    var classes = [CompletedSubjects]()
    var formatedData = [CompletedTableCell]()
    var headers: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getCompletedSubjects()
        self.headers = self.headers.getYearsForHeader(classes: self.classes)
        self.formatedData = self.formatedData.formatSubjectsForTable(subjects: self.classes)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return self.headers.count
        return self.formatedData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return classes.count
        return (self.formatedData[section].subjects?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "takenSubject", for: indexPath) as! TakenSubjectTableViewCell
        cell.classTitleLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].name?.formatTitle()
        cell.gradeLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].grade
        cell.statusLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].acceptance
        cell.codeLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].code
        cell.totalHoursLabel.text = "\(self.formatedData[indexPath.section].subjects![indexPath.row].hours ?? "") horas de aula"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}
