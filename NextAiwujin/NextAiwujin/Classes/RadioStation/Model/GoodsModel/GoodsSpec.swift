//
//  GoodsSpec.swift
//  NextAiwujin
//  商品规格类
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
//BaseModel
class GoodsSpec {
    @objc var id:Int = 0//规格id
    @objc var name:String = ""//规格名称
    @objc var value:String = ""//规格值
    @objc var type:Int = 1//显示类型 1文字 2图片
    @objc var note:String = ""//备注说明
    @objc var is_del = 0//是否删除 1删除 0未删除
    @objc var seller_id = 0//商家id
    
    init(jsonData:JSON){
        id = jsonData["id"].intValue
        name = jsonData["name"].stringValue
        value = jsonData["value"].stringValue
        type = jsonData["type"].intValue
        note = jsonData["note"].stringValue
        is_del  = jsonData["is_del"].intValue
        seller_id = jsonData["seller_id"].intValue
    }
}
