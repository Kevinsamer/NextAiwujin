//
//  BigPicCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/13.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class BigPicCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.height = 150
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
//        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var cellFrame = layoutAttributes.frame
        cellFrame.size.height = 150
        layoutAttributes.frame = cellFrame
        return layoutAttributes
    }
}
