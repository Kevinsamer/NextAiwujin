//
//  UIAlertController-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
extension UIAlertController{
    
    ///自定义alert的title和取消按钮的title
    func showMyAlert(title:String, cancelTitle:String){
        self.title = title
        self.addAction(UIAlertAction.init(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: nil))
        self.show()
    }
}
