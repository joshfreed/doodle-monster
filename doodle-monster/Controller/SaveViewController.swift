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

    override func viewDidLoad() {
        super.viewDidLoad()

        monsterName.text = viewModel.name

        nextLetterInput.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        nextLetterInput.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func saveMonster(sender: AnyObject) {
        viewModel.saveTurn(nextLetterInput.text!) {
            self.performSegueWithIdentifier("GoToMainMenu", sender: self)
        }
    }

    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)

        bottomConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
    }

    // MARK: - UITextFieldDelegate

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }

        let charCount = textField.text!.characters.count - range.length + string.characters.count
        return charCount <= 1
    }
}
