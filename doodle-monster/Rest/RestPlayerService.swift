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
    let session: SessionService
    
    init(session: SessionService) {
        self.session = session
    }
    
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {
        let params = [
            "email": username,
            "password": password,
            "displayName": displayName
        ]
        Alamofire
            .request(.POST, DM_API_URL + "/players/register", parameters: params, encoding: .JSON)
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
        
    }
    
    func playerBy(id: String) -> Player? {
        return nil
    }
}
