//
// Created by Josh Freed on 2/12/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import Foundation
import EmitterKit

// MARK: - DoodleMonster Protocol
protocol DoodleMonster {
    
    // MARK: Actions
    func createLobby()
    func cancelLobby()
    func addPlayer(player: Player)
    func removePlayer(playerId: String)
    func canStartGame() -> Bool
    func startGame()
    
    // MARK: Events
    var playerAdded: Event<Player> { get }
    var playerRemoved: Event<Player> { get }
    var newGameStarted: Event<Game> { get }
}

// MARK: - DoodleMonsterApp
class DoodleMonsterApp: DoodleMonster {
    let gameService: GameService
    let session: SessionService
    
    // MARK: Events
    let playerAdded = Event<Player>()
    let playerRemoved = Event<Player>()
    let newGameStarted = Event<Game>()
    
    private(set) var newGamePlayers: [Player] = []
    
    init(gameService: GameService, session: SessionService) {
        self.gameService = gameService
        self.session = session
    }
    
    // MARK:  Actions
    
    func createLobby() {
        guard newGamePlayers.count == 0 else {
            return
        }
        
        newGamePlayers.append(session.currentPlayer!)
    }
    
    func cancelLobby() {
        newGamePlayers = []
    }
    
    func addPlayer(player: Player) {
        guard !newGamePlayers.contains(player) else {
            return
        }
        
        newGamePlayers.append(player)
        playerAdded.emit(player)
    }

    func removePlayer(playerId: String) {
        let matches = newGamePlayers.filter { return $0.id == playerId }
        guard let player = matches.first else {
            return
        }
        guard player != session.currentPlayer! else {
            return
        }

        newGamePlayers.remove(player)
        playerRemoved.emit(player)
    }

    func startGame() {
        guard canStartGame() else {
            return
        }
        
        gameService.createGame(newGamePlayers) { (result) -> () in
            switch result {
            case .Success(let newGame):
                self.newGamePlayers = []
                self.newGameStarted.emit(newGame)
                break
            case .Failure( _): break
            }
        }
    }
    
    func canStartGame() -> Bool {
        return newGamePlayers.count >= 2 && newGamePlayers.count <= 12
    }
}
