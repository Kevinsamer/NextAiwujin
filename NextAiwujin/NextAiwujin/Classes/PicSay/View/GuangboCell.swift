//
//  GuangboCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/17.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class GuangboCell: UITableViewCell {

    @IBOutlet var huiTingTagLabel: UILabel!
    @IBOutlet var zhiBoTagLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var guangboNameLabel: UILabel!
    @IBOutlet var guangboImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guangboNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        zhiBoTagLabel.layer.cornerRadius = 5
        zhiBoTagLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
