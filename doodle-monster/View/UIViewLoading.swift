//
//  UIViewLoading.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/29/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self: UIView {
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{ $0 == "." }.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
