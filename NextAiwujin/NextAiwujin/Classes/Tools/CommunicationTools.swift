//
//  CommunicationTools.swift
//  NextAiwujin
//  组件通讯工具
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
enum Communications: String {
    case SearchResult = "SearchResult"
    case GoodsDetail = "GoodsDetail"
}
class CommunicationTools {
    
    class func post(duration: TimeInterval = 0.01, name: Communications,data: Any?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            SwiftEventBus.post(name.rawValue, sender: data)
        }
    }
    
    class func getCommunications(_ target: AnyObject, name: Communications, queue:OperationQueue? = OperationQueue.current, handler: @escaping ((Notification?) -> Void)){
        SwiftEventBus.on(target, name: name.rawValue, queue: queue, handler: handler)
    }
}
