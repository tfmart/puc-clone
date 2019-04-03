//
//  TakenSubjectsTableViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 26/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class TakenSubjectsTableViewController: UITableViewController {

    let studentModel = StudentModel()
    var classes = [CompletedSubjects]()
    var formatedData = [CompletedTableCell]()
    var headers: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.getCompletedSubjects()
        self.tabBarController?.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "takenSubjects", for: indexPath) as! TakenSubjectsTableViewCell
        // Configure the cell...
        cell.classTitleLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].name?.formatSubjectName()
        cell.gradeLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].grade
        cell.approvalLabel.text = self.formatedData[indexPath.section].subjects![indexPath.row].acceptance
        if self.formatedData[indexPath.section].subjects![indexPath.row].acceptance == "Reprovado" {
            cell.approvalLabel.textColor = UIColor(red:1.00, green:0.15, blue:0.15, alpha:1.0)
        } else {
            cell.approvalLabel.textColor = UIColor(red:0.16, green:0.75, blue:0.07, alpha:1.0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TakenSubjectsTableViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        let tabBarIndex = tabBarController.selectedIndex
//        if tabBarIndex == 1 {
//            self.tableView.setContentOffset(CGPoint.zero, animated: true)
//        }
//    }
}
