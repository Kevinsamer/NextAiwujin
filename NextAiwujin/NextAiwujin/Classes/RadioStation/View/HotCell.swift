//
//  HotCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/6.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class HotCell: UITableViewCell {

    @IBOutlet var marketPriceLabel: UILabel!
    @IBOutlet var sellPriceLabel: UILabel!
    @IBOutlet var goodsNameLabel: UILabel!
    @IBOutlet var goodsImageView: UIImageView!
    @IBOutlet var bottomLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodsNameLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        marketPriceLabel.attributedText = YTools.textAddMiddleLine(text: "￥2333")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
