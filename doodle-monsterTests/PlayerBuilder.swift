//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
@testable import doodle_monster

class PlayerBuilder: Builder {
    var playerId: String?

    static func aPlayer() -> PlayerBuilder {
        return PlayerBuilder()
    }

    func build() -> Player {
        var player = Player()
        player.id = playerId ?? generateId()
        return player
    }

    func withId(_ id: String) -> PlayerBuilder {
        playerId = id
        return self
    }
}
