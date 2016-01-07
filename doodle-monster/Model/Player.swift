//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import Parse

class Player: PFUser {
    @NSManaged var displayName: String

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
