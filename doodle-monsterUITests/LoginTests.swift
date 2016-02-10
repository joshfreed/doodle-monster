//
//  doodle_monsterUITests.swift
//  doodle-monsterUITests
//
//  Created by Josh Freed on 9/9/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import XCTest

class LoginTests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = ["TESTING"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_CreateNewUserByEmail() {
        let app = XCUIApplication()

        LoginPage(app: app).loginWithEmailAddress()
        
        let loginWithEmailPage = LoginWithEmailPage(app: app)
        loginWithEmailPage.emailAddress("josh@bleepsmazz.com")
        loginWithEmailPage.password("bleep")
        loginWithEmailPage.login()
        
        let createAccountPage = CreateAccountPage(app: app)
        XCTAssertEqual("josh@bleepsmazz.com", createAccountPage.emailAddress())
        createAccountPage.confirmPassword("bleep")
        createAccountPage.displayName("Josh")
        createAccountPage.createAccount()
        
        XCTAssert(app.buttons["Sign Out"].exists)
    }
    
    func test_LogInWithAnExistingUser() {
        let app = XCUIApplication()
        
        LoginPage(app: app).loginWithEmailAddress()
        
        let loginWithEmailPage = LoginWithEmailPage(app: app)
        loginWithEmailPage.emailAddress("jeffery@bleepsmazz.com")
        loginWithEmailPage.password("bleep")
        loginWithEmailPage.login()
     
        XCTAssert(app.buttons["Sign Out"].exists)
    }
}
