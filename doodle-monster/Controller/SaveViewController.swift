//
//  SaveViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/22/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var nextLetterInput: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var viewModel: DrawingViewModel!
    let loadingSpinner = LoadingSpinner()

    override func viewDidLoad() {
        super.viewDidLoad()

        monsterName.text = viewModel.name

        nextLetterInput.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(SaveViewController.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SaveViewController.keyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
        nextLetterInput.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nextLetterInput.resignFirstResponder()
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func saveMonster(_ sender: AnyObject) {
        if let nc = navigationController {
            loadingSpinner.show(inView: nc.view)
        }
        
        viewModel.saveTurn(nextLetterInput.text!) { err in
            self.loadingSpinner.hide()
            
            guard err == nil else {
                return self.showErrorAlert(err!, title: "Error")
            }
            
            self.performSegue(withIdentifier: "GoToMainMenu", sender: self)
        }
    }

    func keyboardWillShowNotification(_ notification: Notification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

//    func keyboardWillHideNotification(notification: NSNotification) {
//        updateBottomLayoutConstraintWithNotification(notification)
//    }

    func updateBottomLayoutConstraintWithNotification(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else {
            return
        }
        
        guard let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)

        bottomConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }

        let charCount = textField.text!.characters.count - range.length + string.characters.count
        return charCount <= 1
    }
}
