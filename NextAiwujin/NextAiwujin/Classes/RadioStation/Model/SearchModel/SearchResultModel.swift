//
//  SearchResultModel.swift
//  NextAiwujin
//  搜索结果实体类
//  Created by DEV2018 on 2019/3/11.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
//BaseModel
class SearchResultModel {
    @objc var id:Int = 0//商品id
    @objc var name:String = ""//商品名
    @objc var sell_price:Double = 0.00//销售价
    @objc var market_price:Double = 0.00//市场价
    @objc var store_nums:Int = 0//库存
    @objc var img:String = ""//图片路径
    @objc var sale:Int = 0//销量
    @objc var grade:Int = 0//评分总数
    @objc var comments:Int = 0//评价数
    @objc var favorite:Int = 0//收藏数
    
    init(jsonData:JSON){
        id = jsonData["id"].intValue
        name = jsonData["name"].stringValue
        sell_price = jsonData["sell_price"].doubleValue
        market_price = jsonData["market_price"].doubleValue
        store_nums = jsonData["store_nums"].intValue
        img = jsonData["img"].stringValue
        sale = jsonData["sale"].intValue
        grade = jsonData["grade"].intValue
        comments = jsonData["comments"].intValue
        favorite = jsonData["favorite"].intValue
    }
    
}
