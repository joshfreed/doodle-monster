//
//  PlayerTableViewCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(viewModel: PlayerViewModelProtocol) {
        self.displayName.text = viewModel.displayName
        self.emailAddress.text = viewModel.email
    }
}
