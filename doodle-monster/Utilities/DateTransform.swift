//
//  DateTransform.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/28/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper

class DateTransform: TransformType {
    let df = DateFormatter()
    
    init() {
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    init(dateFormat: String) {
        df.dateFormat = dateFormat
    }
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let dateString = value as? String else {
            return nil
        }
        
        return df.date(from: dateString)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let date = value else {
            return nil
        }
        
        return df.string(from: date)
    }
}
