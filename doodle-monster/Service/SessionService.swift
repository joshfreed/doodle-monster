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
    var currentPlayer: Player? { get }

    func hasSession() -> Bool
    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ())
    func logout()
    func resume()
}

class ParseSessionService: SessionService {
    var currentPlayer: Player?

    private(set) var player: Player?
    let playerTranslator = ParsePlayerTranslator()

    func hasSession() -> Bool {
        return PFUser.currentUser() != nil
    }

    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {
        PFUser.query()?.whereKey("username", equalTo: username).getFirstObjectInBackgroundWithBlock() { (user, error) -> Void in
            if let error = error {
                if error.code == 101 {
                    callback(result: .NoSuchUser)
                    return
                } else {
                    // Some other error occurred other than the "allowed" error "user not found"
                    callback(result: .Error)
                    return
                }
            }

            guard user != nil else {
                // so what does this mean? That the query succeeded without an error but there was no user object returned?
                // But it seems when a parse search does not find a result it actually sends back an error above
                // So I don't know if it's possible to get here or what it even means if it happens
                print("do what now?")
                callback(result: .Error)
                return
            }

            PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
                // todo handle errors

                guard let user = user else {
                    fatalError("what what what?")
                }

                self.currentPlayer = self.playerTranslator.parseToModel(user)

                callback(result: .Success)
            }
        }
    }

    func logout() {
        player = nil
        PFUser.logOut()
    }

    func resume() {
        if let currentUser = PFUser.currentUser() {
            currentPlayer = playerTranslator.parseToModel(currentUser)
        }
    }
}
