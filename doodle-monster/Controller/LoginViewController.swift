//
//  ViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/9/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    let loadingSpinner = LoadingSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginByEmail" {
            if let vc = segue.destination as? LoginByEmailViewController {
                vc.presenter = appDelegate.viewModelFactory.loginByEmailPresenter(vc)
            }
        }
    }
    
    @IBAction func unwindToLoginScreen(_ segue: UIStoryboardSegue) {
    }

    @IBAction func loginByFacebook(_ sender: UIButton) {
        loadingSpinner.show(inView: navigationController!.view)
        
        let loginManager = LoginManager()

        loginManager.logIn([.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.sendToServer(token: accessToken.authenticationToken)
            }
        }
    }
    
    private func sendToServer(token: String) {
        self.appDelegate.session.loginByFacebook(withToken: token) { result in
            switch result {
            case .success(let user):
                self.loadingSpinner.hide()
                // todo go to main menu
                break
            case .failure(let err): self.showAlert(error: err)
            }
        }
    }
}

