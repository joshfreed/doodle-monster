//
//  PlayerTableViewCell.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, CellProtocol {
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ item: PlayerViewModel) {
        self.displayName.text = item.displayName
        self.emailAddress.text = item.email
    }
}
