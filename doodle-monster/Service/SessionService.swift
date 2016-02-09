//
//  SessionService.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/5/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

protocol SessionService {
    func hasSession() -> Bool
    func currentPlayer() -> Player?
    func logout()
}

class ParseSessionService: SessionService {
    private(set) var player: Player?
    let playerTranslator = ParsePlayerTranslator()

    func hasSession() -> Bool {
        return PFUser.currentUser() != nil
    }

    func currentPlayer() -> Player? {
        guard let currentUser = PFUser.currentUser() else {
            return nil
        }

        if player == nil {
            player = playerTranslator.parseToModel(currentUser)
        }

        return player
    }

    func logout() {
        player = nil
        PFUser.logOut()
    }
}
