//
// Created by Josh Freed on 2/12/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ itemToRemove: Element) {
        guard let index = index(of: itemToRemove) else {
            print("Item not found \(itemToRemove)")
            return
        }

        self.remove(at: index)
    }
}
