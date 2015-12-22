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
    init(view: LoginByEmailView, userService: UserService)
    func login(username: String, password: String)
}

class LoginByEmailPresenter: LoginByEmailViewPresenter {
    let view: LoginByEmailView
    let userService: UserService
    
    required init(view: LoginByEmailView, userService: UserService) {
        self.view = view
        self.userService = userService
    }
    
    func login(username: String, password: String) {
        userService.tryToLogIn(username, password: password) { result in
            switch result {
            case .Success: self.view.goToMainMenu()
            case .NoSuchUser: self.view.goToCreateAccount(username, password: password)
            case .Error: self.view.showError()
            }
        }
    }
}
