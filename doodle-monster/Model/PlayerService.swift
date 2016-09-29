//
//  PlayerService.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/22/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

enum LoginResult {
    case success
    case noSuchUser
    case failed
    case error
}

enum CreateUserResult {
    case success
    case error
}

enum SearchResult {
    case success([Player])
    case error
}
