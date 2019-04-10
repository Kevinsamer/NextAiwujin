//
//  NewsViewCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SkeletonView
class NewsViewCell: UITableViewCell {

    @IBOutlet var videoTag: UILabel!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.frame.size.width = finalScreenW / 3
        newsImageView.frame.size.height = self.frame.size.height - 50
        newsTitle.frame.size.width = finalScreenW * 2 / 3 - 40
//        self.showAnimatedSkeleton()
        self.showAnimatedSkeleton()
//        videoTag.showAnimatedGradientSkeleton()
//        newsImageView.showAnimatedGradientSkeleton()
//        newsTitle.showAnimatedGradientSkeleton()
        newsTitle.lastLineFillPercent = 70
        newsTitle.linesCornerRadius = 5
        videoTag.layer.borderWidth = 1
        videoTag.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        videoTag.layer.cornerRadius = videoTag.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
