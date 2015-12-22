//
//  LoginByEmailPresenter.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/22/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

protocol LoginByEmailView {
    func goToMainMenu()
    func goToCreateAccount(username: String, password: String)
    func showError()
}

protocol LoginByEmailViewPresenter {
    init(view: LoginByEmailView)
    func login(username: String, password: String)
}

class LoginByEmailPresenter: LoginByEmailViewPresenter {
    let view: LoginByEmailView
    
    required init(view: LoginByEmailView) {
        self.view = view
    }
    
    func login(username: String, password: String) {
        PFUser.query()?.whereKey("username", equalTo: username).getFirstObjectInBackgroundWithBlock() { (user, error) -> Void in
            if let error = error {
                if error.code == 101 {
                    self.view.goToCreateAccount(username, password: password)
                    return
                } else {
                    // Some other error occurred other than the "allowed" error "user not found"
                    print("unexpected error \(error)")
                }
            }
            
            guard user != nil else {
                // so what does this mean? That the query succeeded without an error but there was no user object returned?
                // But it seems when a parse search does not find a result it actually sends back an error above
                // So I don't know if it's possible to get here or what it even means if it happens
                print("do what now?")
                return
            }
            
            PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
                self.view.goToMainMenu()
            }
        }
    }
}
