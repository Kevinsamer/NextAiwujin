//
//  JoinCartModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwiftyJSON
class JoinCartModel {
    var isError:Bool = false//true:加入购物车错误--false:加入购物车成功
    var message:String = ""//附加信息
    
    init(jsonData: JSON) {
        isError = jsonData["isError"].boolValue
        message = jsonData["message"].stringValue
    }
}
