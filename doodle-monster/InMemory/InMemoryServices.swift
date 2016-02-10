//
//  InMemoryServices.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/9/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MemoryPlayerService: PlayerService {
    var players: [Player] = []
    var nextId = 0
    let session: MemorySessionService
    
    init(session: MemorySessionService) {
        self.session = session
    }
    
    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {
        var foundPlayer = false
        for player in players {
            if player.username == username {
                foundPlayer = true
                break
            }
        }
        if !foundPlayer {
            return callback(result: .NoSuchUser)
        }
        
        for player in players {
            if player.username == username && player.password == password {
                session.setCurrentPlayer(player)
                return callback(result: .Success)
            }
        }
        
        callback(result: .Error)
    }
    
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {
        nextId = nextId + 1
        var player = Player()
        player.id = String(nextId)
        player.username = username
        player.password = password
        player.displayName = displayName
        players.append(player)
        session.setCurrentPlayer(player)
        callback(result: .Success)
    }
    
    func search(searchText: String, callback: (result: SearchResult) -> ()) {
        
    }
}

class MemoryGameService: GameService {
    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        
    }
    
    func getActiveGames(callback: ([Game]) -> ()) {
        
    }
    
    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {
        
    }
}

class MemorySessionService: SessionService {
    private(set) var curPlayer: Player?
    
    func setCurrentPlayer(player: Player) {
        curPlayer = player
    }
    
    func hasSession() -> Bool {
        return curPlayer != nil
    }
    
    func currentPlayer() -> Player? {
        return curPlayer
    }
    
    func logout() {
        curPlayer = nil
    }
}
