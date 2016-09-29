//
//  Player.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Foundation
import ObjectMapper

struct Player: Mappable, Equatable {
    var id: String?
    var username: String?
    var password: String?
    var displayName: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["email"]
        displayName <- map["displayName"]
    }
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.id == rhs.id
}
