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
    let playerTranslator: ParsePlayerTranslator
    
    private var players: [Player] = []
    
    init(apiUrl: String, session: SessionService, playerTranslator: ParsePlayerTranslator) {
        self.apiUrl = apiUrl
        self.session = session
        self.playerTranslator = playerTranslator
    }
    
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {
        let params = [
            "email": username,
            "password": password,
            "displayName": displayName
        ]
        Alamofire
            .request(.POST, apiUrl + "/players/register", parameters: params, encoding: .JSON)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback(result: .Error)
                    return
                }
                
                guard let
                    data = response.result.value as? NSDictionary,
                    playerDict = data["player"] as? NSDictionary,
                    token = data["token"] as? String
                else {
                    callback(result: .Error)
                    return
                }
                
                self.session.setAuthToken(token, andPlayer: playerDict)
                
                callback(result: .Success)
            }
        
    }
    
    func search(searchText: String, callback: (result: SearchResult) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        Alamofire
            .request(.GET, apiUrl + "/players?email=" + searchText, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    guard let objects = json as? [NSDictionary] else {
                        return callback(result: .Error)
                    }
                    
                    var players: [Player] = []
                    for user in objects {
                        let player = self.playerTranslator.dictionaryToModel(user)
                        players.append(player)
                        self.players.append(player)
                    }
                    callback(result: SearchResult.Success(players))
                case .Failure(let error): callback(result: .Error)
                }
            }
    }
    
    func playerBy(id: String) -> Player? {
        for object in players {
            if object.id == id {
                return object
            }
        }
        
        return nil
    }
}
