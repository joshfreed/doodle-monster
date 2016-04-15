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
    init(view: LoginByEmailView, session: SessionService)
    func login(username: String, password: String)
}

class LoginByEmailPresenter: LoginByEmailViewPresenter {
    let view: LoginByEmailView
    let session: SessionService
    
    required init(view: LoginByEmailView, session: SessionService) {
        self.view = view
        self.session = session
    }
    
    func login(username: String, password: String) {
        session.tryToLogIn(username, password: password) { result in
            switch result {
            case .Success: self.view.goToMainMenu()
            case .NoSuchUser: self.view.goToCreateAccount(username, password: password)
            case .Failed: self.view.showError()
            case .Error: self.view.showError()
            }
        }
    }
}
