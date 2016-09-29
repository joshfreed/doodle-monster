//
//  ApiService.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol DoodMonApi {
    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ())
    func loginByFacebook(withToken accessToken: String, completion: @escaping (Result<Bool>) -> ())
    
    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ())
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ())
    func playerBy(_ id: String) -> Player?
    
    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ())
    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ())
    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ())
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ())
}

class ApiService: DoodMonApi {
    let apiUrl: String
        
    fileprivate var players: [Player] = []
    
    init(baseUrl: String) {
        self.apiUrl = baseUrl
    }

    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    // MARK: - Auth
    
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
                        playerDict = data["player"] as? [String: Any],
                        let token = data["token"] as? String,
                        let player = Mapper<Player>().map(JSON: playerDict)
                        else {
                            callback(.error)
                            return
                    }
                    
                    self.appDelegate.session.setSession(token: token, player: player)
                    
                    callback(.success)
                }
        }
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
                    let json = json as? [String: Any],
                        let token = json["token"] as? String,
                        let playerJson = json["player"] as? [String: Any],
                        let player = Mapper<Player>().map(JSON: playerJson)
                        else {
                            completion(.failure(DoodMonError.unexpectedResponse))
                            return
                    }
                    
                    self.appDelegate.session.setSession(token: token, player: player)
                    
                    completion(.success(true))
                case .failure(let error): completion(.failure(self.parseErrorType(error, data: response.data)))
                    break
                }
        }
    }
    
    // MARK: - Player
    
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
                    let playerJson = data["player"] as? [String: Any],
                    let token = data["token"] as? String,
                    let player = Mapper<Player>().map(JSON: playerJson)
                else {
                    return callback(.error)
                }
                
                self.appDelegate.session.setSession(token: token, player: player)
                
                callback(.success)
        }
        
    }
    
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ()) {
        guard let token = appDelegate.session.token else {
            return callback(.error)
        }
        
        let headers = [
            "Authorization": "Bearer " + token,
        ]
        Alamofire
            .request(apiUrl + "/players?email=" + searchText, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let jsonArray = json as? [[String: Any]] else {
                        return callback(.error)
                    }
                    
                    guard let players = Mapper<Player>().mapArray(JSONArray: jsonArray) else {
                        return callback(.error)
                    }
                    
                    self.players = players
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

    // MARK: - Game
    
    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ()) {
        guard let token = appDelegate.session.token else {
            return callback(.failure(DoodMonError.noToken))
        }
        
        let headers = [
            "Authorization": "Bearer " + token
        ]
        
        var playerIds: [String] = []
        for player in players {
            playerIds.append(player.id!)
        }
        let params = [
            "players": playerIds
        ]
        
        Alamofire
            .request(apiUrl + "/monsters", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .success(let json):
                    print(json)
                    guard let data = json as? [String: Any] else {
                        // successful http request; bad data from server
                        callback(.failure(DoodMonError.unexpectedResponse))
                        return
                    }
                    
                    guard let game = Mapper<Game>().map(JSON: data) else {
                        callback(.failure(DoodMonError.unexpectedResponse))
                        return
                    }
                    
                    callback(.success(game))
                case .failure(let error): callback(.failure(self.parseErrorType(error, data: response.data)))
                }
        }
    }
    
    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ()) {
        guard let token = appDelegate.session.token else {
            return callback(.failure(DoodMonError.noToken))
        }
        
        let headers = [
            "Authorization": "Bearer " + token
        ]
        
        Alamofire
            .request(apiUrl + "/me/monsters", headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .success(let json):
                    guard let objects = json as? [[String: Any]] else {
                        print(json)
                        return
                    }
                    
                    guard let games = Mapper<Game>().mapArray(JSONArray: objects) else {
                        callback(.failure(DoodMonError.unexpectedResponse))
                        return
                    }
                    
                    callback(.success(games))
                case .failure(let error): callback(.failure(self.parseErrorType(error, data: response.data)))
                }
        }
    }
    
    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ()) {
        guard let token = appDelegate.session.token else {
            return completion(.failure(DoodMonError.noToken))
        }
        
        let headers = [
            "Authorization": "Bearer " + token
        ]
        
        let url = apiUrl + "/monster/" + gameId + "/turns"
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "imageData", fileName: "monster_turn.png", mimeType: "image/png")
                multipartFormData.append(letter.data(using: String.Encoding.utf8)!, withName: "letter")
            },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            print(response.response)
                            
                            switch response.result {
                            case .success(let json):
                                print(json)
                                guard let data = json as? [String: Any] else {
                                    // successful http request; bad data from server
                                    completion(.failure(DoodMonError.unexpectedResponse))
                                    return
                                }
                                
                                guard let game = Mapper<Game>().map(JSON: data) else {
                                    completion(.failure(DoodMonError.unexpectedResponse))
                                    return
                                }
                                
                                completion(.success(game))
                            case .failure(let error): completion(.failure(self.parseErrorType(error, data: response.data)))
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ()) {
        guard let token = appDelegate.session.token else {
            return completion(.failure(DoodMonError.noToken))
        }
        
        let headers = [
            "Authorization": "Bearer " + token
        ]
        
        Alamofire
            .request(apiUrl + "/monster/" + gameId, headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response)
                
                switch response.result {
                case .success(let json):
                    guard let
                        dict = json as? NSDictionary,
                        let encodedData = dict["imageData"] as? String,
                        let imageData = Data(base64Encoded: encodedData, options: NSData.Base64DecodingOptions(rawValue: 0))
                        else {
                            print(json)
                            return
                    }
                    
                    completion(.success(imageData))
                case .failure(let error): completion(.failure(self.parseErrorType(error, data: response.data)))
                }
        }
    }
    
    // Mark: - Privates
    
    fileprivate func parseErrorType(_ error: Error, data: Data?) -> Error {
        print(error)
        
        if let errTuple = self.parseErrorData(data) {
            return DoodMonError.httpError(code: errTuple.code, message: errTuple.message)
        }
        
        return DoodMonError.serverError(message: error.localizedDescription)
    }
    
    fileprivate func parseErrorData(_ data: Data?) -> (code: String, message: String)? {
        guard let data = data else {
            return nil
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: AnyObject]
            if let
                object = object,
                let code = object["code"] as? String,
                let message = object["message"] as? String
            {
                return (code: code, message: message)
            }
        } catch {
            
        }
        
        return nil
    }
}
