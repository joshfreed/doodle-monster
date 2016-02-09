//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

struct Player: Equatable {
    var id: String?
    var username: String?
    var displayName: String?
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.id == rhs.id
}