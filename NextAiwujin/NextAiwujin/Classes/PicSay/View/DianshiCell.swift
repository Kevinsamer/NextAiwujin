//
//  DianshiCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class DianshiCell: UITableViewCell {

    @IBOutlet var updateTimeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
