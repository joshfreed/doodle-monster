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
    func goToCreateAccount(_ username: String, password: String)
    func showError()
    func showLoading()
    func hideLoading()
}

protocol LoginByEmailViewPresenter {
    init(view: LoginByEmailView, api: DoodMonApi)
    func login(_ username: String, password: String)
}

class LoginByEmailPresenter: LoginByEmailViewPresenter {
    let view: LoginByEmailView
    let api: DoodMonApi
    
    required init(view: LoginByEmailView, api: DoodMonApi) {
        self.view = view
        self.api = api
    }
    
    func login(_ username: String, password: String) {
        view.showLoading()
        
        api.tryToLogIn(username, password: password) { result in
            self.view.hideLoading()
            
            switch result {
            case .success: self.view.goToMainMenu()
            case .noSuchUser: self.view.goToCreateAccount(username, password: password)
            case .failed: self.view.showError()
            case .error: self.view.showError()
            }
        }
    }
}
