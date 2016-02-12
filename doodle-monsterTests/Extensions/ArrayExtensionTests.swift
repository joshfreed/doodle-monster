//
//  ArrayExtensionTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/12/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class ArrayExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_remove_removesTheItemFromTheArray() {
        var array = [TestType(id: 1), TestType(id: 2), TestType(id: 3)]

        array.remove(TestType(id: 2))

        XCTAssertEqual(2, array.count)
        XCTAssertFalse(array.contains(TestType(id: 2)))
    }

    func test_remove_elementNotInTheArray_doesNotDoAnything() {
        var array = [TestType(id: 1), TestType(id: 2), TestType(id: 3)]
        array.remove(TestType(id: 999))
        XCTAssertEqual(3, array.count)
    }
}

struct TestType: Equatable {
    let id: Int
    let rando: Int

    init(id: Int) {
        self.id = id
        self.rando = Int(arc4random_uniform(1000))
    }
}

func ==(lhs: TestType, rhs: TestType) -> Bool {
    return lhs.id == rhs.id
}