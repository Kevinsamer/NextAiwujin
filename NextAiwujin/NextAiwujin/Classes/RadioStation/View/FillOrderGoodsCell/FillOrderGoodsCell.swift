//
//  FillOrderGoodsCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class FillOrderGoodsCell: UITableViewCell {

    @IBOutlet var goodsNumLabel: UILabel!
    @IBOutlet var goodsPriceLabel: UILabel!
    @IBOutlet var goodsStandardsLabel: UILabel!
    @IBOutlet var goodsNameLabel: UILabel!
    @IBOutlet var goodsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
