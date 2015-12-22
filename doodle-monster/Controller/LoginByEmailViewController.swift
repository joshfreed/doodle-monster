//
//  LoginByEmailViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/14/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class LoginByEmailViewController: UIViewController, LoginByEmailView {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: LoginByEmailViewPresenter!
    var username: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreateAccount" {
            if let vc = segue.destinationViewController as? CreateAccountViewController {
                vc.presenter = CreateAccountPresenter(view: vc, username: username!, password: password!)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func login(sender: UIButton) {
        guard let
            username = usernameTextField.text,
            password = passwordTextField.text
            where !username.isEmpty && !password.isEmpty else
        {
            return
        }
        
        presenter.login(username, password: password)
    }
    
    @IBAction func unwindToLoginByEmailScreen(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - LoginByEmail
    
    func goToMainMenu() {
        
    }
    
    func goToCreateAccount(username: String, password: String) {
        self.username = username
        self.password = password
        self.performSegueWithIdentifier("CreateAccount", sender: self)
    }
    
    func showError() {
        
    }
}
