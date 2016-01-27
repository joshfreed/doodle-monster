//
//  MonsterSectionFooter.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/22/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MonsterSectionFooter: UICollectionReusableView, SupplementaryView {
    weak var viewModel: MainMenuViewModelProtocol?

    func configure(section: Int) {
        guard viewModel != nil else {
            fatalError("viewModel must not be nil");
        }

        if section == 1 {
            let nib = UINib(nibName: MainMenuBottom.nibName, bundle: NSBundle(forClass: MainMenuBottom.self))
            let bottom = nib.instantiateWithOwner(nil, options: nil)[0] as! MainMenuBottom
            bottom.viewModel = viewModel!
            bottom.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(bottom)
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: bottom, attribute: .Top, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: bottom, attribute: .Bottom, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: bottom, attribute: .Leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: bottom, attribute: .Trailing, multiplier: 1, constant: 0))
        }
    }
}

class MonsterFooterViewFactory: SupplementaryViewFactory<MonsterSectionFooter> {
    weak var viewModel: MainMenuViewModelProtocol?

    init(viewModel: MainMenuViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func buildView(collectionView: UICollectionView, kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = super.buildView(collectionView, kind: kind, atIndexPath: indexPath) as! MonsterSectionFooter
        view.viewModel = viewModel
        return view
    }
}