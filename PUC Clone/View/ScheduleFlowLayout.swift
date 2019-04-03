//
//  ScheduleFlowLayour.swift
//  PUC Clone
//
//  Created by Tomas Martins on 15/02/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class ScheduleFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        let cellWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        self.itemSize = CGSize(width: cellWidth, height: (cellWidth*108)/337)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
        
    }
}
