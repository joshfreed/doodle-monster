//
//  RestPlayerService.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Alamofire

class RestPlayerService: PlayerService {
    let apiUrl: String
    let session: SessionService
    let playerTranslator: DictionaryPlayerTranslator
    
    fileprivate var players: [Player] = []
    
    init(apiUrl: String, session: SessionService, playerTranslator: DictionaryPlayerTranslator) {
        self.apiUrl = apiUrl
        self.session = session
        self.playerTranslator = playerTranslator
    }
    
    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ()) {
        let params = [
            "email": username,
            "password": password,
            "displayName": displayName
        ]
        Alamofire
            .request(apiUrl + "/players/register", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback(.error)
                    return
                }
                
                guard let
                    data = response.result.value as? NSDictionary,
                    let playerDict = data["player"] as? NSDictionary,
                    let token = data["token"] as? String
                else {
                    callback(.error)
                    return
                }
                
                self.session.setAuthToken(token, andPlayer: playerDict)
                
                callback(.success)
            }
        
    }
    
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        Alamofire
            .request(apiUrl + "/players?email=" + searchText, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let objects = json as? [NSDictionary] else {
                        return callback(.error)
                    }
                    
                    var players: [Player] = []
                    for user in objects {
                        let player = self.playerTranslator.dictionaryToModel(user)
                        players.append(player)
                        self.players.append(player)
                    }
                    callback(SearchResult.success(players))
                case .failure(let error): callback(.error)
                }
            }
    }
    
    func playerBy(_ id: String) -> Player? {
        for object in players {
            if object.id == id {
                return object
            }
        }
        
        return nil
    }
}
