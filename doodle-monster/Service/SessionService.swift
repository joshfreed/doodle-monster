//
//  SessionService.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/5/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper

protocol DoodMonSession {
    var me: Player? { get }
    var token: String? { get }
    
    func hasSession() -> Bool
    func setSession(token: String, player: Player)
    func logout()
    func resume()
}

class Session: DoodMonSession {
    private(set) var me: Player?
    private(set) var token: String?
    
    func hasSession() -> Bool {
        return me != nil
    }
    
    func setSession(token: String, player: Player) {
        self.token = token
        me = player
        let json = Mapper().toJSON(player)
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.setValue(json, forKey: "player")
    }
    
    func logout() {
        clearToken()
    }
    
    func resume() {
        guard
            let token = UserDefaults.standard.value(forKey: "token") as? String,
            let playerJson = UserDefaults.standard.value(forKey: "player") as? [String: Any],
            let me = Mapper<Player>().map(JSON: playerJson)
        else {
            clearToken()
            return
        }
        
        print(token)
        
        self.token = token
        self.me = me
    }
    
    private func clearToken() {
        token = nil
        me = nil
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "player")
    }
}
