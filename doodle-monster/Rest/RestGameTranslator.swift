//
//  RestGameTranslator.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class RestGameTranslator {
    let playerTranslator = DictionaryPlayerTranslator()
    
    func dictionaryToModel(object: NSDictionary) -> Game {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        var game = Game()
        game.id = object["id"] as? String
        game.name = object["name"] as? String ?? ""
        game.gameOver = object["gameOver"] as? Bool ?? false
        game.players = playerTranslator.parseArray(object["players"] as! NSArray)
        game.currentPlayerNumber = object["currentPlayerNumber"] as? Int ?? 0
        
        if let thumbnail = object["thumbnail"] as? String {
            game.thumbnail = NSData(base64EncodedString: thumbnail, options: NSDataBase64DecodingOptions(rawValue: 0))
        } else {
            game.thumbnail = NSData()
        }
        
        if let lastTurn = object["lastTurn"] as? String, formatted = dateFormatter.dateFromString(lastTurn) {
            game.lastTurn = formatted
        }

        return game
    }
}
