//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

struct Player {
    let email: String
    var displayName: String
    
    init(email: String, displayName: String) {
        self.email = email
        self.displayName = displayName
    }
}

extension Player: Equatable {}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.email == rhs.email
        && lhs.displayName == lhs.displayName
}