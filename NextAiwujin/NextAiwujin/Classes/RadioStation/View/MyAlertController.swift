//
//  MyAlertController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class MyAlertController: UIAlertController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //标题字体样式（红色，字体放大）
        let titleFont = UIFont.systemFont(ofSize: 20)
        let titleAttribute = NSMutableAttributedString.init(string: self.title!)
        titleAttribute.addAttributes([NSAttributedString.Key.font:titleFont,
                                      NSAttributedString.Key.foregroundColor:UIColor.black],
                                     range:NSMakeRange(0, (self.title?.count)!))
        self.setValue(titleAttribute, forKey: "attributedTitle")
        
        //消息内容样式（灰色斜体）
        let messageFontDescriptor = UIFontDescriptor.init(fontAttributes: [
            UIFontDescriptor.AttributeName.family:"Arial",
            UIFontDescriptor.AttributeName.name:"Arial-ItalicMT",
            ])
        
        let messageFont = UIFont.init(descriptor: messageFontDescriptor, size: 13.0)
        let messageAttribute = NSMutableAttributedString.init(string: self.message!)
        messageAttribute.addAttributes([NSAttributedString.Key.font:messageFont,
                                        NSAttributedString.Key.foregroundColor:UIColor.gray],
                                       range:NSMakeRange(0, (self.message?.count)!))
        self.setValue(messageAttribute, forKey: "attributedMessage")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
