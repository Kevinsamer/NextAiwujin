//
//  CenterHomeCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class CenterHomeCell: UITableViewCell {
    @IBOutlet var iconImage: UIImageView!
    
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = #colorLiteral(red: 0.3215686275, green: 0.3411764706, blue: 0.3725490196, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
