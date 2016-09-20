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

    func configure(_ section: Int) {
        guard viewModel != nil else {
            fatalError("viewModel must not be nil");
        }

        if section == 1 {
            let nib = UINib(nibName: MainMenuBottom.nibName, bundle: Bundle(for: MainMenuBottom.self))
            let bottom = nib.instantiate(withOwner: nil, options: nil)[0] as! MainMenuBottom
            bottom.viewModel = viewModel!
            bottom.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(bottom)
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: bottom, attribute: .top, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bottom, attribute: .bottom, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: bottom, attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: bottom, attribute: .trailing, multiplier: 1, constant: 0))
        }
    }
}

class MonsterFooterViewFactory: SupplementaryViewFactory<MonsterSectionFooter> {
    weak var viewModel: MainMenuViewModelProtocol?

    init(viewModel: MainMenuViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func buildView(_ collectionView: UICollectionView, kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let view = super.buildView(collectionView, kind: kind, atIndexPath: indexPath) as! MonsterSectionFooter
        view.viewModel = viewModel
        return view
    }
}
