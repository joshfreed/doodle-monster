//
//  RestGameTranslator.swift
//  doodle-monster
//
//  Created by Josh Freed on 5/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class RestGameTranslator {
    func dictionaryToModel(object: NSDictionary) -> Game {
        var game = Game()
        game.id = object["id"] as? String
        
        return game
    }
}
