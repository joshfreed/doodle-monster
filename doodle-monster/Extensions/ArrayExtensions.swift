//
// Created by Josh Freed on 2/12/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(itemToRemove: Element) {
        guard let index = indexOf(itemToRemove) else {
            print("Item not found \(itemToRemove)")
            return
        }

        removeAtIndex(index)
    }
}