//
//  InviteByEmailViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol InviteByEmailView {
    func displaySearchResults()
    func displaySearchError()
}

protocol InviteByEmailViewModelProtocol: class {
    var players: [PlayerViewModel] { get }

    init(view: InviteByEmailView, playerService: PlayerService, session: SessionService, applicationLayer: DoodleMonster)
    func search(text: String)
    func selectPlayer(index: NSIndexPath)
}

class InviteByEmailViewModel: InviteByEmailViewModelProtocol {
    var players: [PlayerViewModel] {
        return playerViewModels
    }

    private let view: InviteByEmailView
    private let session: SessionService
    private let playerService: PlayerService
    private let appLayer: DoodleMonster
    private var playerViewModels: [PlayerViewModel] = []
    
    required init(view: InviteByEmailView, playerService: PlayerService, session: SessionService, applicationLayer: DoodleMonster) {
        self.view = view
        self.playerService = playerService
        self.session = session
        self.appLayer = applicationLayer
    }

    func setPlayers(players: [Player]) {
        playerViewModels = players
            .filter({ return $0 != session.currentPlayer })
            .map({ return PlayerViewModel(player: $0) })
    }
    
    // MARK: - InviteByEmailViewModelProtocol

    func search(text: String) {
        playerService.search(text) { result in
            switch result {
            case .Success(let players):
                self.setPlayers(players)
                self.view.displaySearchResults()
            case .Error: self.view.displaySearchError()
            }
        }
    }

    func selectPlayer(index: NSIndexPath) {
        guard index.row >= 0 && index.row < players.count else {
            return
        }

        let playerId = players[index.row].id

        guard let player = playerService.playerBy(playerId) else {
            print("No player with id \(playerId)")
            return
        }

        appLayer.addPlayer(player)
    }
}
