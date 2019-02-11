//
//  UIDevice-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    //判断是否为X系列机型
    public func isX() -> Bool{
        if (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)! > CGFloat(0) {
            return true
        }
        return false
    }
}
