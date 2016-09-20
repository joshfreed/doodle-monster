//
//  GameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/2/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

protocol GameService {
    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ())
    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ())
    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ())
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ())
}
