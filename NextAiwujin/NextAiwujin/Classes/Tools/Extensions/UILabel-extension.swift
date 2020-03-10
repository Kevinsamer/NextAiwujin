//
//  UILabel-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2020/2/13.
//  Copyright © 2020 DEV2018. All rights reserved.
//

import Foundation

extension UILabel {
    
    /// 设置UILabel的字间距和行间距
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    func changeLabelRowSpace(line lineSpace: CGFloat, word wordSpace: CGFloat) {
        guard let content = self.text else {return}
      let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: content)
      let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (content.count)))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpace, range: NSMakeRange(0, (content.count)))
      self.attributedText = attributedString
      self.sizeToFit()
    }
}
