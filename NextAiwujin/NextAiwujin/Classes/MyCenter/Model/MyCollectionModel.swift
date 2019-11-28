//
//  MyCollectionModel.swift
//  NextAiwujin
//  收藏model
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyCollectionModel {
    var image:String = ""
    var goodsName:String = ""
    
    init(jsonData:JSON) {
        image = jsonData["image"].stringValue
        goodsName = jsonData["goodsName"].stringValue
    }
}
