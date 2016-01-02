//
//  LoginPresenter.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/14/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol CreateAccountView {
    func goToMainMenu()
    func showCreateAccountError()
    func setUsername(username: String)
}

protocol CreateAccountViewPresenter {
    init(view: CreateAccountView, playerService: PlayerService, username: String, password: String)
    func createAccount(displayName: String, confirmPassword: String)
    func showUsername()
}

class CreateAccountPresenter: CreateAccountViewPresenter {
    let view: CreateAccountView
    let playerService: PlayerService
    let username: String
    let password: String
    
    required init(view: CreateAccountView, playerService: PlayerService, username: String, password: String) {
        self.view = view
        self.playerService = playerService
        self.username = username
        self.password = password
    }
    
    func createAccount(displayName: String, confirmPassword: String) {
        guard !username.isEmpty && !password.isEmpty else {
            // the previous view controller sent us bad data
            return
        }
        
        if password != confirmPassword {
            // blah blah tell the user to make the passwords match
            return
        }
        
        playerService.createUser(username, password: password, displayName: displayName) { result in
            switch result {
            case .Success: self.view.goToMainMenu()
            case .Error: self.view.showCreateAccountError()
            }
        }
    }
    
    func showUsername() {
        self.view.setUsername(username)
    }
}
