//
//  RestSessionService.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Alamofire

class RestSessionService: SessionService {
    let apiUrl: String
    var currentPlayer: Player?
    var token: String?
    
    let playerTranslator = ParsePlayerTranslator()
    
    init(apiUrl: String) {
        self.apiUrl = apiUrl
    }
    
    func hasSession() -> Bool {
        return currentPlayer != nil
    }
    
    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {
        let params = [
            "email": username,
            "password": password
        ]
        Alamofire
            .request(.POST, apiUrl + "/auth/email", parameters: params, encoding: .JSON)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback(result: .Error)
                    return
                }
                
                print("response value: \(response.result.value)")
                guard let data = response.result.value as? [String:AnyObject],
                    result = data["result"] as? String
                else {
                    callback(result: .Error)
                    return
                }
                
                if result == "NoSuchPlayer" {
                    callback(result: .NoSuchUser)
                } else if result == "LoginFailed" {
                    callback(result: .Failed)
                } else if result == "OK" {
                    guard let
                        playerDict = data["player"] as? NSDictionary,
                        token = data["token"] as? String
                    else {
                        callback(result: .Error)
                        return
                    }
                    
                    self.setAuthToken(token, andPlayer: playerDict)
                    callback(result: .Success)
                }
            }
    }
    
    func logout() {
        clearToken()
        // Rest API -> POST /logout
    }
    
    func resume() {
        guard let
            token = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String,
            playerDict = NSUserDefaults.standardUserDefaults().valueForKey("player") as? NSDictionary
        else {
            // no token, or invalid token
            clearToken()
            return
        }
        
        self.token = token
        currentPlayer = playerTranslator.dictionaryToModel(playerDict)
    }
    
    func setAuthToken(token: String, andPlayer playerDict:NSDictionary) {
        self.token = token
        self.currentPlayer = self.playerTranslator.dictionaryToModel(playerDict)
        NSUserDefaults.standardUserDefaults().setValue(token, forKey: "token")
        NSUserDefaults.standardUserDefaults().setValue(playerDict, forKey: "player")
    }
    
    func clearToken() {
        self.token = nil
        self.currentPlayer = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("player")
    }
}