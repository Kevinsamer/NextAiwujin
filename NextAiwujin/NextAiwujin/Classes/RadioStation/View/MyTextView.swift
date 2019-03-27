//
//  MyTextView.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class MyTextView: UITextView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    override func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        super.textRange(from: fromPosition, to: toPosition)
        return UITextRange.init()
    }
    
    
}
