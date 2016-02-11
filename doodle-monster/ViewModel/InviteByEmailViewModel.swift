//
//  InviteByEmailViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol InviteByEmailViewModelProtocol: class {
    var players: [PlayerViewModelProtocol] { get }
    var playersDidChange: ((InviteByEmailViewModelProtocol) -> ())? { get set }

    init(playerService: PlayerService, session: SessionService)
    func search(text: String)
    func playerAt(index: Int) -> PlayerViewModelProtocol
    func selectPlayer(index: NSIndexPath)
}

class InviteByEmailViewModel: InviteByEmailViewModelProtocol {
    var players: [PlayerViewModelProtocol] = [] {
        didSet {
            playersDidChange?(self)
        }
    }
    
    var playersDidChange: ((InviteByEmailViewModelProtocol) -> ())?

    private let session: SessionService
    private let playerService: PlayerService
    private var playerModels: [Player] = []

    required init(playerService: PlayerService, session: SessionService) {
        self.playerService = playerService
        self.session = session
    }
    
    func search(text: String) {
        playerService.search(text) { result in
            switch result {
            case .Success(let players): self.processSearchResults(players)
            case .Error: break
            }
        }
    }

    private func processSearchResults(players: [Player]) {
        let currentPlayer = session.currentPlayer!
        var viewModels: [PlayerViewModelProtocol] = []
        for player in players {
            if player == currentPlayer {
                continue
            }

            viewModels.append(PlayerViewModel(player: player))
        }
        self.playerModels = players
        self.players = viewModels
    }

    func playerAt(index: Int) -> PlayerViewModelProtocol {
        return players[index]
    }

    func selectPlayer(index: NSIndexPath) {
        let wrapped = Wrapper<Player>(theValue: playerModels[index.row])
        NSNotificationCenter.defaultCenter().postNotificationName("NewMonster:PlayerAdded", object: nil, userInfo: ["player": wrapped])
    }
}
