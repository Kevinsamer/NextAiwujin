//
//  RecommendCell.swift
//  NextAiwujin
//  商城首页今日推荐模块cell
//  Created by DEV2018 on 2019/3/5.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell {

    @IBOutlet var marketPriceLabel: UILabel!
    @IBOutlet var sellPriceLabel: UILabel!
    @IBOutlet var goodsNameLabel: UILabel!
    @IBOutlet var goodsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodsNameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
    }

}
