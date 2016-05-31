//
//  WaitingCellCollectionViewCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/10/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class WaitingCell: UICollectionViewCell, CollectionViewCell {
    @IBOutlet weak var monsterThumbnail: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var currentPlayerInfo: UILabel!
    @IBOutlet weak var lastTurnInfo: UILabel!
    
    func configure(item: GameViewModel) {
        monsterName.text = item.monsterName
        currentPlayerInfo.text = item.currentPlayerName
        lastTurnInfo.text = item.lastTurnText
        
        if let imageData = item.game.thumbnail {
            monsterThumbnail.image = UIImage(data: imageData)
        }
    }
}
