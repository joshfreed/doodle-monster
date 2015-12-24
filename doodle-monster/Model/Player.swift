//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class Player: NSObject {
    let email: String
    var displayName: String
    
    init(email: String, displayName: String) {
        self.email = email
        self.displayName = displayName
    }
}
