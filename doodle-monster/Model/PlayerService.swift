//
//  PlayerService.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/22/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol PlayerService {
    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ())
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ())
    func playerBy(_ id: String) -> Player?
}

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
