//
//  ZhiBoCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ZhiBoCell: UITableViewCell {
    var huikan:Bool = false {
        didSet{
            if !oldValue {
                if huikan{
//                    print(titleLabel.height)
//                    titleLabel.height *= 2
//                    titleLabel.numberOfLines = 2
//                    print(titleLabel.height)
                    statusLabel.text = "回顾"
                }
            }else{
                if !huikan{
//                    titleLabel.height *= 2
//                    titleLabel.numberOfLines = 2
                    statusLabel.text = "直播"
                }
            }
        }
    }
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.clipsToBounds = true
        statusLabel.layer.cornerRadius = 5
        statusLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5647058824, blue: 0.5960784314, alpha: 1)
        statusLabel.textColor = .white
        titleLabel.width = 20
        titleLabel.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        titleLabel.sizeToFit()
        descLabel.baselineAdjustment = UIBaselineAdjustment.none
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 5
//        self.layoutIfNeeded()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
