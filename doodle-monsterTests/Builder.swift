//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol Builder {
    typealias Entity
    func build() -> Entity
}

extension Builder {
    func generateId() -> String {
        return randomStringWithLength(6) as! String
    }

    func randomStringWithLength(len: Int) -> NSString {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString: NSMutableString = NSMutableString(capacity: len)

        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }

        return randomString
    }
}