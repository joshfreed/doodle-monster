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
    
    func dictionaryToModel(_ object: NSDictionary) -> Game {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        var game = Game()
        game.id = object["id"] as? String
        game.name = object["name"] as? String ?? ""
        game.gameOver = object["gameOver"] as? Bool ?? false
        game.players = playerTranslator.parseArray(object["players"] as! NSArray)
        game.currentPlayerNumber = object["currentPlayerNumber"] as? Int ?? 0
        
        if let thumbnail = object["thumbnail"] as? String {
            game.thumbnail = Data(base64Encoded: thumbnail, options: NSData.Base64DecodingOptions(rawValue: 0))
        } else {
            game.thumbnail = Data()
        }
        
        if let lastTurn = object["lastTurn"] as? String, let formatted = dateFormatter.date(from: lastTurn) {
            game.lastTurn = formatted
        }

        return game
    }
}
