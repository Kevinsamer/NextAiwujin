//
//  Header.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit


let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height
let KBtncol = UIColor.red
func kSize(width:CGFloat)->CGFloat{
    return CGFloat(width*(kWidth/375))
}

func cutCorner(cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor,view:UIView)
{
    view.layer.cornerRadius = cornerRadius
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = borderWidth
    view.layer.masksToBounds = true
}
