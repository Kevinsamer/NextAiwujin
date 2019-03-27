//
//  CGRect-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

extension CGRect {
    init(view:UIView, viewSize size:CGSize) {
        self.init(origin: view.frame.origin, size: size)
    }
}
