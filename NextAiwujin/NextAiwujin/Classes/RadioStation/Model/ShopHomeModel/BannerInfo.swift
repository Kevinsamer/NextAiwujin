//
//  BannerInfo.swift
//  NextAiwujin
//  首页轮播数据类
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//
//"banner_info":[
//{
//"name":"1",
//"url":"1",
//"img":"upload/2017/12/22/20171222124939273.jpg"
//},
//{
//"name":"2",
//"url":"2",
//"img":"upload/2017/12/22/20171222125026683.jpg"
//}

import Foundation
import SwiftyJSON
//BaseModel
class BannerInfo {
    @objc var name:String = "" //banner name
    @objc var url:String = ""//banner指向的商品url
    @objc var img:String = ""//图片路径
    
    init(jsonData:JSON) {
        name = jsonData["name"].stringValue
        url = jsonData["url"].stringValue
        img = jsonData["img"].stringValue
    }
}
