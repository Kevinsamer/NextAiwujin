//
//  BaoLiaoTableCellTableViewCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2020/1/9.
//  Copyright © 2020 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
class BaoLiaoTableCellTableViewCell: UITableViewCell {

    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.text! += "\n \n \n"
        contentLabel.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        leftLabel.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        rightLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
