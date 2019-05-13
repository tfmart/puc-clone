//
//  Style.swift
//  PUC Clone
//
//  Created by Tomas Martins on 01/05/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

//File with extensions used to style UIViews

import Foundation

extension TodaysClassesCollectionViewCell {
    func styleCell() {
        self.layer.cornerRadius = 8.0
        self.layer.applySketchShadow()
        self.layer.masksToBounds = true
    }
}

extension AVACollectionViewCell {
    func styleCell() {
        self.layer.cornerRadius = 8.0
        self.layer.applySketchShadow()
        self.layer.masksToBounds = true
    }
}

extension TodayView {
    func styleNoClassView() {
        noClassMessageView.layer.cornerRadius = 8.0
        noClassMessageView.layer.applySketchShadow()
        noClassMessageView.layer.masksToBounds = true
    }
}
