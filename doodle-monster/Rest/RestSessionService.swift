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
    
    let playerTranslator = DictionaryPlayerTranslator()
    
    init(apiUrl: String) {
        self.apiUrl = apiUrl
    }
    
    func hasSession() -> Bool {
        return currentPlayer != nil
    }

    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ()) {
        let params = [
            "email": username,
            "password": password
        ]

        Alamofire
            .request(apiUrl + "/auth/email", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback(.error)
                    return
                }
                
                print("response value: \(response.result.value)")
                guard let data = response.result.value as? [String:AnyObject],
                    let result = data["result"] as? String
                else {
                    callback(.error)
                    return
                }
                
                if result == "NoSuchPlayer" {
                    callback(.noSuchUser)
                } else if result == "LoginFailed" {
                    callback(.failed)
                } else if result == "OK" {
                    guard let
                        playerDict = data["player"] as? NSDictionary,
                        let token = data["token"] as? String
                    else {
                        callback(.error)
                        return
                    }
                    
                    self.setAuthToken(token, andPlayer: playerDict)
                    callback(.success)
                }
            }
    }
    
    func logout() {
        clearToken()
        // Rest API -> POST /logout
    }
    
    func resume() {
        guard let
            token = UserDefaults.standard.value(forKey: "token") as? String,
            let playerDict = UserDefaults.standard.value(forKey: "player") as? NSDictionary
        else {
            // no token, or invalid token
            clearToken()
            return
        }
        
        self.token = token
        currentPlayer = playerTranslator.dictionaryToModel(playerDict)
    }
    
    func setAuthToken(_ token: String, andPlayer playerDict: NSDictionary) {
        self.token = token
        self.currentPlayer = self.playerTranslator.dictionaryToModel(playerDict)
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.setValue(playerDict, forKey: "player")
    }
    
    func clearToken() {
        self.token = nil
        self.currentPlayer = nil
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "player")
    }
    
    func loginByFacebook(withToken accessToken: String, completion: @escaping (Result<Bool>) -> ()) {
        print(accessToken)
        
        let params = ["accessToken": accessToken]
        
        Alamofire
            .request(apiUrl + "/auth/fb", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
                switch response.result {
                case .success(let json):
                    guard
                        let json = json as? NSDictionary,
                        let token = json["token"] as? String,
                        let playerJson = json["player"] as? NSDictionary
                    else {
                        completion(.failure(DoodMonError.unexpectedResponse))
                        return
                    }

                    self.setAuthToken(token, andPlayer: playerJson)
                    completion(.success(true))
                case .failure(let err):
//                    completion(.failure(self.buildError(err, response.data)))
                    break
                }
            }
    }
}
