//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper
@testable import doodle_monster

class PlayerBuilder: Builder {
    var playerId: String?
    var displayName: String?

    static func aPlayer() -> PlayerBuilder {
        return PlayerBuilder()
    }

    func build() -> Player {
        var json: [String: Any] = [:]
        var player = Mapper<Player>().map(JSON: json)!
        player.id = playerId ?? generateId()
        player.displayName = displayName
        return player
    }

    func withId(_ id: String) -> PlayerBuilder {
        playerId = id
        return self
    }

    func withName(_ name: String) -> PlayerBuilder {
        displayName = name
        return self
    }
}
