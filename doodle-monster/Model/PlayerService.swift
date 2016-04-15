//
//  PlayerService.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/22/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol PlayerService {
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ())
    func search(searchText: String, callback: (result: SearchResult) -> ())
    func playerBy(id: String) -> Player?
}

enum LoginResult {
    case Success
    case NoSuchUser
    case Failed
    case Error
}

enum CreateUserResult {
    case Success
    case Error
}

enum SearchResult {
    case Success([Player])
    case Error
}
