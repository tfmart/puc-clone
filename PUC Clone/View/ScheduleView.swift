//
//  ViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 29/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class ScheduleView: UIViewController {
    let currentDate = Date()
    let studentModel = StudentModel()
    var weekString: String!
    var actualClasses = [Schedule]()
    var flowLayout =  ScheduleFlowLayout()
    
    //Button IBOutlets
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thrusdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var weekButtonStackView: UIStackView!
    @IBOutlet weak var classesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.title = currentDate.scheduleDateTitle()
        self.getWeeklySchedule()
        self.tabBarController?.delegate = self
        
        if let dayOfTheWeek = currentDate.getDayOfTheWeek() {
            weekString = dayOfTheWeek
            self.setUpButtons(dayString: dayOfTheWeek)
        }
        
        self.classesCollectionView.alwaysBounceVertical = true
        self.classesCollectionView.collectionViewLayout = flowLayout
        self.classesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        classesCollectionView.reloadData()
    }
    
    @IBAction func dayWeekButtonPressed(_ sender: UIButton) {
        setUpButtons(dayString: sender.currentTitle!)
        weekString = sender.currentTitle!
        classesCollectionView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScheduleView:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let subjectOnDay = self.actualClassesToday(subjects: actualClasses, weekString: weekString)
        return subjectOnDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! ClassCollectionViewCell
        var subjectOnDay = self.actualClassesToday(subjects: actualClasses, weekString: weekString)
        cell.fillActualCells(subject: subjectOnDay[indexPath.row], dayOfTheWeek: weekString)
        return cell
    }
}

extension ScheduleView: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            self.classesCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
