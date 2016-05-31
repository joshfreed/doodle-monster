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
    let apiUrl: String
    let session: SessionService
    let gameTranslator: RestGameTranslator
    
    init(apiUrl: String, session: SessionService, gameTranslator: RestGameTranslator) {
        self.apiUrl = apiUrl
        self.session = session
        self.gameTranslator = gameTranslator
    }
    
    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        
        var playerIds: [String] = []
        for player in players {
            playerIds.append(player.id!)
        }
        let params = [
            "players": playerIds
        ]
        
        Alamofire
            .request(.POST, apiUrl + "/monsters", parameters: params, headers: headers, encoding: .JSON)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .Success(let json):
                    print(json)
                    guard let data = json as? NSDictionary else {
                        // successful http request; bad data from server
                        callback(.Failure(DoodMonError.ServerError))
                        return
                    }
                    
                    let game = self.gameTranslator.dictionaryToModel(data)
                    callback(.Success(game))
                    
                    break
                    
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
    
    func getActiveGames(callback: (Result<[Game]>) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        Alamofire
            .request(.GET, apiUrl + "/me/monsters", headers: headers)
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
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        
        let url = apiUrl + "/monster/" + gameId + "/turns"
        
        Alamofire.upload(
            .POST,
            url,
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: image, name: "imageData", fileName: "monster_turn.png", mimeType: "image/png")
                multipartFormData.appendBodyPart(data: letter.dataUsingEncoding(NSUTF8StringEncoding)!, name: "letter")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            print(response.response)
                            
                            switch response.result {
                            case .Success(let json):
                                print(json)
                                guard let data = json as? NSDictionary else {
                                    // successful http request; bad data from server
                                    completion(.Failure(DoodMonError.ServerError))
                                    return
                                }
                                
                                let game = self.gameTranslator.dictionaryToModel(data)
                                completion(.Success(game))
                                
                                break
                                
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
                                            completion(.Failure(DoodMonError.HttpError(code: code, message: message)))
                                            return
                                        }
                                    } catch {
                                        
                                    }
                                    
                                    completion(.Failure(DoodMonError.ServerError))
                                }
                            }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func loadImageData(gameId: String, completion: (Result<NSData>) -> ()) {
        let headers = [
            "Authorization": "Bearer " + session.token!,
        ]
        Alamofire
            .request(.GET, apiUrl + "/monster/" + gameId, headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .Success(let json):
                    guard let
                        dict = json as? NSDictionary,
                        encodedData = dict["imageData"] as? String,
                        imageData = NSData(base64EncodedString: encodedData, options: NSDataBase64DecodingOptions(rawValue: 0))
                    else {
                        print(json)
                        return
                    }

                    completion(.Success(imageData))
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
                                completion(.Failure(DoodMonError.HttpError(code: code, message: message)))
                                return
                            }
                        } catch {
                            
                        }
                        
                        completion(.Failure(DoodMonError.ServerError))
                    }
                }
        }
    }
}
