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
    var playerWasSelected: ((PlayerViewModelProtocol) -> ())? { get set }
    
    init(playerService: PlayerService)
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
    var playerWasSelected: ((PlayerViewModelProtocol) -> ())?
    
    private let playerService: PlayerService

    required init(playerService: PlayerService) {
        self.playerService = playerService
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
        let currentPlayer = playerService.getCurrentPlayer()!
        var viewModels: [PlayerViewModelProtocol] = []
        for player in players {
            if player == currentPlayer {
                continue
            }

            viewModels.append(PlayerViewModel(player: player))
        }
        self.players = viewModels
    }

    func playerAt(index: Int) -> PlayerViewModelProtocol {
        return players[index]
    }

    func selectPlayer(index: NSIndexPath) {
        playerWasSelected?(players[index.row])
    }
}
