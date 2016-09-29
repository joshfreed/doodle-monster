//
//  Base64Transform.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/28/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper

class Base64Transform: TransformType {
    func transformFromJSON(_ value: Any?) -> Data? {
        guard let value = value as? String else {
            return nil
        }
        
        return Data(base64Encoded: value, options: NSData.Base64DecodingOptions(rawValue: 0))
    }
    
    func transformToJSON(_ value: Data?) -> String? {
        guard let value = value else {
            return nil
        }
        
        return value.base64EncodedString(options: .lineLength64Characters)
    }
}
