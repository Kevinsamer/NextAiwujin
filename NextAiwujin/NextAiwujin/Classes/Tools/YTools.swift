//
//  YTools.swift
//  NextAiwujin
//  工具类
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
class YTools{
    ///文字添加中划线，返回NSAttributedString
    class func textAddMiddleLine(text: String) -> NSAttributedString{
        let attributeText = NSMutableAttributedString(string: text)
        attributeText.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributeText.length))
        attributeText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeText.length))
        attributeText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:attributeText.length))
        return attributeText
    }
    
}
