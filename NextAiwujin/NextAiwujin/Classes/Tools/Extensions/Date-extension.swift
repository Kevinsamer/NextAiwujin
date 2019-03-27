//
//  Date-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
extension Date{
    static func now() -> Date{
        let now = Date()
        let zone = TimeZone.current
        let integer = zone.secondsFromGMT(for: now)
        return now.addingTimeInterval(TimeInterval(integer))
    }
}
