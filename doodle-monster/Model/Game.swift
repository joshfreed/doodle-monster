//
//  Game.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

class Game: PFObject, PFSubclassing {
    @NSManaged var gameOver: Bool
    @NSManaged var players: [Player]
    @NSManaged var currentPlayer: Player
    @NSManaged var imageFile: PFFile?
    @NSManaged var thumbnail: PFFile?

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

    func isCurrentTurn(player: Player) -> Bool {
        return currentPlayer.objectId == player.objectId
    }

    func isWaitingForAnotherPlayer(player: Player) -> Bool {
        return currentPlayer.objectId != player.objectId
    }
}
