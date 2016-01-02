//
//  LoginByEmailPresenter.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/22/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol LoginByEmailView {
    func goToMainMenu()
    func goToCreateAccount(username: String, password: String)
    func showError()
}

protocol LoginByEmailViewPresenter {
    init(view: LoginByEmailView, playerService: PlayerService)
    func login(username: String, password: String)
}

class LoginByEmailPresenter: LoginByEmailViewPresenter {
    let view: LoginByEmailView
    let playerService: PlayerService
    
    required init(view: LoginByEmailView, playerService: PlayerService) {
        self.view = view
        self.playerService = playerService
    }
    
    func login(username: String, password: String) {
        playerService.tryToLogIn(username, password: password) { result in
            switch result {
            case .Success: self.view.goToMainMenu()
            case .NoSuchUser: self.view.goToCreateAccount(username, password: password)
            case .Error: self.view.showError()
            }
        }
    }
}
