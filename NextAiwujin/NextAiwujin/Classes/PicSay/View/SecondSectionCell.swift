//
//  SecondSectionCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/17.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class SecondSectionCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // 弧度计算方法，(真实cell的宽度=110 * 5 / 7) * (imageV和cell宽度的比例=0.7) / 2
        imageV.layer.cornerRadius = (110 * 5 / 7) * 0.7 / 2
        imageV.clipsToBounds = true
        imageV.layer.borderWidth = 1
        imageV.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageV.contentMode = .scaleAspectFit
        titleLabel.adjustsFontSizeToFitWidth = true
    }

}
