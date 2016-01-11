//
//  DrawingViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol DrawingViewModelProtocol {
    init(game: Game)
}

class DrawingViewModel: NSObject {
    private let game: Game
    
    required init(game: Game) {
        self.game = game
    }
}
