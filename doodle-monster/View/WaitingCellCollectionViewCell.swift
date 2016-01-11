//
//  WaitingCellCollectionViewCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/10/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class WaitingCellCollectionViewCell: UICollectionViewCell, CellProtocol {
    @IBOutlet weak var monsterThumbnail: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var currentPlayerInfo: UILabel!
    @IBOutlet weak var lastTurnInfo: UILabel!
    
    func configure(item: GameViewModel) {
        currentPlayerInfo.text = item.currentPlayerName
    }
}
