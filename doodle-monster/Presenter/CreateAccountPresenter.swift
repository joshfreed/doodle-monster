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
}

protocol CreateAccountViewPresenter {
    init(view: CreateAccountView, username: String, password: String)
    func createAccount(displayName: String, confirmPassword: String)
}

class CreateAccountPresenter: CreateAccountViewPresenter {
    let view: CreateAccountView
    let username: String
    let password: String
    
    required init(view: CreateAccountView, username: String, password: String) {
        self.view = view
        self.username = username
        self.password = password
    }
    
    func createAccount(displayName: String, confirmPassword: String) {
//        guard !username.isEmpty && !password.isEmpty else {
//            // the previous view controller sent us bad data
//            return
//        }
//        
//        if password != confirmPassword {
//            // blah blah tell the user to make the passwords match
//        }
    }
}
