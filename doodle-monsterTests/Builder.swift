//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol Builder {
    associatedtype Entity
    func build() -> Entity
}

extension Builder {
    func generateId() -> String {
        return randomStringWithLength(6)
    }

    func randomStringWithLength(len: Int) -> String {
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString: String = ""

        for _ in 0..<len {
            let length = UInt32(letters.characters.count)
            let rand = arc4random_uniform(length)
            randomString += String(letters.characters[letters.startIndex.advancedBy(Int(rand))])
        }

        return randomString
    }
}