//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/24/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import Parse

class ParsePlayerTranslator {
    func parseToModel(parsePlayer: PFObject) -> Player {
        var player = Player()
        player.id = parsePlayer.objectId
        player.username = parsePlayer["username"] as? String
        player.displayName = parsePlayer["displayName"] as? String
        return player
    }
    
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
            } else if let parse = object as? PFObject {
                players.append(parseToModel(parse))
            } else {
                print("dubs tee eff")
            }

        }
        return players
    }
}