//
//  Game.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

class ParseGame: PFObject, PFSubclassing {
    @NSManaged var gameOver: Bool
    @NSManaged var players: NSArray
    @NSManaged var imageFile: PFFile?
    @NSManaged var thumbnail: PFFile?
    @NSManaged var name: String
    @NSManaged var lastTurn: NSDate
    @NSManaged var currentPlayerNumber: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    static func parseClassName() -> String {
        return "Game"
    }
}
