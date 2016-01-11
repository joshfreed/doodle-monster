//
//  YourTurnCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class YourTurnCell: UICollectionViewCell, CellProtocol {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var playerInfo: UILabel!
    
    func configure(item: GameViewModel) {
        monsterName.text = "Barry"
    }
}
