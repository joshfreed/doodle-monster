//
//  ParsePlayerService.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class ParseUserService: PlayerService {
    let playerTranslator = ParsePlayerTranslator()
    var parseObjects: [PFObject] = []

    func objectFor(player: Player) -> PFObject? {
        for object in parseObjects {
            if object.objectId == player.id {
                return object
            }
        }

        return nil
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
                
                callback(result: .Success)
            }
        }
    }
    
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {
        let user = PFUser()
        user.username = username
        user.password = password
        user["displayName"] = displayName
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                callback(result: .Error)
            } else {
                callback(result: .Success)
            }
        }
    }
    
    func search(searchText: String, callback: (result: SearchResult) -> ()) {
        if searchText.isEmpty {
            callback(result: .Success([]))
            return
        }
        
        PFUser.query()?.whereKey("username", hasPrefix: searchText).findObjectsInBackgroundWithBlock { results, error in
            guard let results = results else {
                callback(result: .Error)
                return
            }
            
            var players: [Player] = []
            for user in results {
                self.parseObjects.append(user)
                players.append(self.playerTranslator.parseToModel(user))
            }
            callback(result: .Success(players))
        }
    }
}