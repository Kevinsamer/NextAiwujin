//
//  ZhiBoIngCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/5/20.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ZhiBoIngCell: UITableViewCell {
    @IBOutlet var imageV: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var noZhiBoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let topColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let buttomColor = UIColor.black
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        let gradientLayer = CAGradientLayer()
        //cell高度为100，imageV上下间距各10，imageV高度为80，以此设定gradientLayer.frame
        let cellHeight = finalScreenW / 16 * 9
        gradientLayer.frame = CGRect(x: 0, y: (cellHeight)/2, width: finalScreenW, height: (cellHeight)/2)
        gradientLayer.colors = gradientColors
        //imageV.layer.addSublayer(gradientLayer)
        //也可以这样：
        imageV.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
