//
//  RemoveCartModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class RemoveCartModel{
    var isError:Bool?
    var message:String?
    var data:String?
    
    init(jsonData:JSON) {
        isError = jsonData["isError"].boolValue
        message = jsonData["message"].stringValue
        data = jsonData["data"].stringValue
    }
    
    //    空参构造
    //    init() {
    //
    //    }
}
