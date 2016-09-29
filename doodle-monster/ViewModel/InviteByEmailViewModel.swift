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

    init(view: InviteByEmailView, api: DoodMonApi, session: DoodMonSession, applicationLayer: DoodleMonster)
    func search(_ text: String)
    func selectPlayer(_ index: IndexPath)
}

class InviteByEmailViewModel: InviteByEmailViewModelProtocol {
    var players: [PlayerViewModel] {
        return playerViewModels
    }

    fileprivate let view: InviteByEmailView
    fileprivate let session: DoodMonSession
    fileprivate let api: DoodMonApi
    fileprivate let appLayer: DoodleMonster
    fileprivate var playerViewModels: [PlayerViewModel] = []
    
    required init(view: InviteByEmailView, api: DoodMonApi, session: DoodMonSession, applicationLayer: DoodleMonster) {
        self.view = view
        self.api = api
        self.session = session
        self.appLayer = applicationLayer
    }

    func setPlayers(_ players: [Player]) {
        playerViewModels = players
            .filter({ return $0 != session.me })
            .map({ return PlayerViewModel(player: $0) })
    }
    
    // MARK: - InviteByEmailViewModelProtocol

    func search(_ text: String) {
        api.search(text) { result in
            switch result {
            case .success(let players):
                self.setPlayers(players)
                self.view.displaySearchResults()
            case .error: self.view.displaySearchError()
            }
        }
    }

    func selectPlayer(_ index: IndexPath) {
        guard (index as NSIndexPath).row >= 0 && (index as NSIndexPath).row < players.count else {
            return
        }

        let playerId = players[(index as NSIndexPath).row].id

        guard let player = api.playerBy(playerId) else {
            print("No player with id \(playerId)")
            return
        }

        appLayer.addPlayer(player)
    }
}
