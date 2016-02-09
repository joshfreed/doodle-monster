//
//  GameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/2/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

protocol GameService {
    func createGame(players: [Player], callback: (Result<Game>) -> ())
    func getActiveGames(callback: ([Game]) -> ())
    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ())
}

