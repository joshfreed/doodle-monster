//
//  GameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/2/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

protocol GameService {
    func createGame(players: [Player])
}

class ParseGameService: GameService {
    func createGame(players: [Player]) {
        let newGame = PFObject(className: "Game")
        let relation = newGame.relationForKey("players")
        for player in players {
            relation.addObject(player)
        }
        newGame.saveInBackground()
    }
}
