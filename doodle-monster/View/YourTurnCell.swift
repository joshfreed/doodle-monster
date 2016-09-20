//
//  YourTurnCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class YourTurnCell: UICollectionViewCell, CollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var playerInfo: UILabel!
    
    func configure(_ item: GameViewModel) {
        monsterName.text = item.monsterName
        playerInfo.text = item.playerInfo
        
        if let imageData = item.game.thumbnail {
            thumbnail.image = UIImage(data: imageData as Data)
        }
    }
}
