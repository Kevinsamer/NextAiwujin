//
//  GoodsPhoto.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
//BaseModel
class GoodsPhoto {
    @objc var img:String = ""//详情页轮播图片
    
    init(jsonData:JSON){
        img = jsonData["img"].stringValue
    }
}
