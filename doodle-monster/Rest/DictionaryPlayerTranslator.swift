//
//  DictionaryPlayerTranslator.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class DictionaryPlayerTranslator {
    func dictionaryToModel(object: NSDictionary) -> Player {
        var player = Player()
        player.id = object["id"] as? String
        player.username = object["email"] as? String
        player.displayName = object["displayName"] as? String
        return player
    }
    
    func parseArray(objects: NSArray) -> [Player] {
        var players: [Player] = []
        for object in objects {
            if let dict = object as? NSDictionary {
                players.append(dictionaryToModel(dict))
            } else {
                print("dubs tee eff")
            }
            
        }
        return players
    }
}
