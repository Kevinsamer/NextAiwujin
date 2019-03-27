//
//  UIImageView-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/20.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView{
    class func loadNetImage(url:String){
        self.init().kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "Image_unselect"))
    }
}
