//
//  LoginByEmailViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/14/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class LoginByEmailViewController: UIViewController, LoginByEmailView, SegueHandlerType {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    enum SegueIdentifier: String {
        case CreateAccount
        case MainMenu
    }

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
        guard let identifier = segue.identifier, segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).")
        }

        switch segueIdentifier {
        case .CreateAccount:
            if let vc = segue.destinationViewController as? CreateAccountViewController {
                vc.presenter = CreateAccountPresenter(view: vc, playerService: appDelegate.playerService, username: username!, password: password!)
            }
        case .MainMenu:
            if let vc = segue.destinationViewController as? MainMenuViewController, currentPlayer = appDelegate.session.currentPlayer() {
                vc.viewModel = appDelegate.viewModelFactory.mainMenuViewModel(vc)
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
        performSegueWithIdentifier(.MainMenu, sender: self)
    }
    
    func goToCreateAccount(username: String, password: String) {
        self.username = username
        self.password = password
        self.performSegueWithIdentifier(.CreateAccount, sender: self)
    }
    
    func showError() {
        
    }
}
