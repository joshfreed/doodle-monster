//
//  NewGame.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class NewGame: NSObject {
    var players: [Player] = []
    
    func addPlayer(player: Player) {
        players.append(player)
    }
}
