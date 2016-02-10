//
//  Pages.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/10/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest

struct LoginPage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func loginWithEmailAddress() {
        app.buttons["email button"].tap()
    }
}

struct LoginWithEmailPage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func emailAddress(addr: String) {
        let emailAddressTextField = app.textFields["email address"]
        emailAddressTextField.tap()
        emailAddressTextField.typeText(addr)
        
    }
    
    func password(pw: String) {
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(pw)
        
    }
    
    func login() {
        app.buttons["Login"].tap()
    }
}

struct CreateAccountPage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func emailAddress() -> String {
        let emailAddr = app.staticTexts["EmailAddress"]
        return emailAddr.label
    }
    
    func confirmPassword(pw: String) {
        let confirmPasswordSecureTextField = app.secureTextFields["confirm password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText(pw)
    }
    
    func displayName(name: String) {
        let displayNameTextField = app.textFields["display name"]
        displayNameTextField.tap()
        displayNameTextField.typeText(name)
        
    }
    
    func createAccount() {
        app.buttons["Login"].tap()
    }
}