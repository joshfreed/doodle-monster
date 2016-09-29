//
//  InMemoryServices.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/9/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper

class InMemoryApiService: DoodMonApi {
    let session: InMemorySession
    var players: [Player] = []
    var games: [Game] = []
    var nextId = 0
    
    init(session: InMemorySession) {
        self.session = session
    }
    
    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ()) {
        var foundPlayer = false
        for player in players {
            if player.username == username {
                foundPlayer = true
                break
            }
        }
        if !foundPlayer {
            return callback(.noSuchUser)
        }
        
        for player in players {
            if player.username == username && player.password == password {
                session.me = player
                return callback(.success)
            }
        }
        
        callback(.error)
    }
    
    func loginByFacebook(withToken accessToken: String, completion: @escaping (Result<Bool>) -> ()) {
        
    }
    
    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ()) {
        nextId = nextId + 1
        
        let json = [
            "id": "\(nextId)",
            "username": username,
            "displayName": displayName
        ]
        
        var player = Mapper<Player>().map(JSON: json)!
        player.password = password
        players.append(player)
        session.me = player
        callback(.success)

    }
    
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ()) {
        var matches: [Player] = []
        for player in players {
            print("Checking \(player.username)")
            if player.username != nil && player.username!.contains(searchText) {
                matches.append(player)
            }
        }
        callback(.success(matches))
    }
    
    func playerBy(_ id: String) -> Player? {
        for player in players {
            if player.id == id {
                return player
            }
        }
        
        return nil
    }
    
    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ()) {
        nextId = nextId + 1
        
        let json: [String : Any] = [
            "id": String(nextId)
        ]
        
        var game = Mapper<Game>().map(JSON: json)!
        game.players = players
        games.append(game)
        callback(.success(game))
    }
    
    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ()) {
        callback(.success(games))
    }
    
    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ()) {
        var game = getGame(gameId)
        if game != nil {
            game!.name = (game!.name ?? "") + letter
            return completion(.success(game!))
        }
        
        completion(.failure(NSError(domain: "Game not found", code: 0, userInfo: nil)))
    }
    
    private func getGame(_ gameId: String) -> Game? {
        for game in games {
            if game.id == gameId {
                return game
            }
        }
        
        return nil
    }
    
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ()) {
        
    }
}

class InMemorySession: DoodMonSession {
    var me: Player?
    var token: String?
    
    func hasSession() -> Bool {
        return me != nil
    }
    
    func setSession(token: String, player: Player) {
        self.token = token
        self.me = player
    }
    
    func logout() {
        self.token = nil
        self.me = nil
    }
    
    func resume() {
        
    }
}

