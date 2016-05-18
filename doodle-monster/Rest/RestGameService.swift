//
//  RestGameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Alamofire

class RestGameService: GameService {
    let session: SessionService
    let gameTranslator: RestGameTranslator
    
    init(session: SessionService, gameTranslator: RestGameTranslator) {
        self.session = session
        self.gameTranslator = gameTranslator
    }
    
    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        
    }
    
    func getActiveGames(callback: (Result<[Game]>) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        Alamofire
            .request(.GET, DM_API_URL + "/me/monsters", headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .Success(let json):
                    guard let objects = json as? [NSDictionary] else {
                        print(json)
                        return
                    }
                    
                    var games: [Game] = []
                    for object in objects {
                        games.append(self.gameTranslator.dictionaryToModel(object))
                    }
                    callback(.Success(games))
                    
                case .Failure(let error):
                    print(error)
                    if let data = response.data {
                        do {
                            let object = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
                            if let
                                object = object,
                                code = object["code"] as? String,
                                message = object["message"] as? String
                            {
                                callback(.Failure(DoodMonError.HttpError(code: code, message: message)))
                                return
                            }
                        } catch {
                            
                        }
                        
                        callback(.Failure(DoodMonError.ServerError))
                    }
                }
            }
    }
    
    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {
        
    }
}
