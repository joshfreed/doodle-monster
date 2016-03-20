//
//  NewMonsterViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import EmitterKit

protocol NewMonsterView {
    func displayPlayer(player: PlayerViewModel)
    func removePlayer(player: PlayerViewModel)
    func updateStartButton()
}

protocol NewMonsterViewModelProtocol {
    var players: [PlayerViewModel] { get }
    var currentPlayer: PlayerViewModel { get }
    var buttonHidden: Bool { get }

    init(view: NewMonsterView, session: SessionService, router: NewMonsterRouter, applicationLayer: DoodleMonster)
    func removePlayer(player: PlayerViewModel)
    func startGame()
}

class NewMonsterViewModel: NewMonsterViewModelProtocol {
    var players: [PlayerViewModel] = []
    var currentPlayer: PlayerViewModel
    var buttonHidden = true

    private let view: NewMonsterView
    private let session: SessionService
    private let router: NewMonsterRouter
    private let appLayer: DoodleMonster
    private var listeners: [Listener] = []

    required init(view: NewMonsterView, session: SessionService, router: NewMonsterRouter, applicationLayer: DoodleMonster) {
        self.view = view
        self.session = session
        self.router = router
        self.appLayer = applicationLayer

        self.currentPlayer = PlayerViewModel(player: session.currentPlayer!)
        
        listeners += appLayer.playerAdded.on { [weak self] n in self?.playerAdded(n) }
        listeners += appLayer.playerRemoved.on { [weak self] n in self?.playerRemoved(n) }
        listeners += appLayer.newGameStarted.on { [weak self] n in self?.router.goToNewMonster(n) }
    }

    deinit {
        print("NewMonsterViewModel::deinit")
    }

    func playerAdded(player: Player) {
        let playerVm = PlayerViewModel(player: player)
        players.append(playerVm)
        view.displayPlayer(playerVm)
        validateGame()
    }
    
    func playerRemoved(player: Player) {
        let vm = PlayerViewModel(player: player)
        players.remove(vm)
        view.removePlayer(vm)
        validateGame()
    }

    func validateGame() {
        buttonHidden = !appLayer.canStartGame()
        view.updateStartButton()
    }

    // MARK: - NewMonsterViewModelProtocol

    func removePlayer(vm: PlayerViewModel) {
        appLayer.removePlayer(vm.id)
    }

    func startGame() {
        appLayer.startGame()
    }
}

struct PlayerViewModel: Equatable {
    var id: String {
        return player.id!
    }

    var email: String {
        if let un = player.username {
            return un
        } else {
            return ""
        }
    }

    var displayName: String {
        return player.displayName ?? ""
    }

    private let player: Player
    
    init(player: Player) {
        self.player = player
    }
}

func ==(lhs: PlayerViewModel, rhs: PlayerViewModel) -> Bool {
    return lhs.player.id == rhs.player.id
}
