//
// Created by Josh Freed on 2/8/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit

class Wrapper<T> {
    let wrappedValue: T
    init(theValue: T) {
        wrappedValue = theValue
    }
}
