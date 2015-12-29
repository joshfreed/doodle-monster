//
//  NewMonsterViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterViewModelProtocol {
    var playerWasAdded: ((InvitedPlayerViewModelProtocol) -> ())? { get set }
    init(userService: UserService)
    func invitePlayerByEmail() -> InviteByEmailViewModelProtocol
}

class NewMonsterViewModel: NewMonsterViewModelProtocol {
    let userService: UserService
    let newGame = NewGame()
    
    var playerWasAdded: ((InvitedPlayerViewModelProtocol) -> ())?
    
    required init(userService: UserService) {
        self.userService = userService
    }
    
    func invitePlayerByEmail() -> InviteByEmailViewModelProtocol {
        let vm = InviteByEmailViewModel(userService: userService)
        vm.playerWasSelected = { player in
            self.newGame.addPlayer(player)
            self.playerWasAdded?(InvitedPlayerViewModel(player: player))
        }
        return vm
    }
}

protocol InvitedPlayerViewModelProtocol {
    var email: String { get }
    var displayName: String { get }
    
    init(player: Player)
}

class InvitedPlayerViewModel: InvitedPlayerViewModelProtocol {
    var email: String {
        return player.email
    }
    var displayName: String {
        return player.displayName
    }
    
    private let player: Player
    
    required init(player: Player) {
        self.player = player
    }
}