//
//  DrawingViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

protocol DrawingViewModelProtocol {
    init(game: Game)
    func save(currentImageData: NSData, fullImageData: NSData)
}

class DrawingViewModel: NSObject {
    let game: Game
    
    required init(game: Game) {
        self.game = game
    }

    func save(currentImageData: NSData, fullImageData: NSData) {
        let currentImageFile = PFFile(name: "turn.png", data: currentImageData)
        let fullImageFile = PFFile(name: "monster.png", data: fullImageData)
        game["imageFile"] = fullImageFile
        game.saveInBackground()
    }
}
