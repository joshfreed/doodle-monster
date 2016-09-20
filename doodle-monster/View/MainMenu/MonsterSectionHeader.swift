//
//  MonsterListCollectionReusableView.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MonsterSectionHeader: UICollectionReusableView, SupplementaryView {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(_ section: Int) {
        if section == 0 {
            titleLabel.text = "Your Turn"
        } else if section == 1 {
            titleLabel.text = "Waiting"
        } else {
            titleLabel.text = ""
        }
    }
}
