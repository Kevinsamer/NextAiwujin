//
//  NSDate-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
extension NSDate {
    //获取1970至今的毫秒数间隔
    class func getCurrentDateInterval() -> String {
        return "\(NSDate().timeIntervalSince1970)"
    }
}
