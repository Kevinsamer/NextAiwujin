//
//  GoodInfo.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//
//{
//    "code":200,
//    "result":{
//        "name":"丰县大沙河苹果甜脆味美爽口多汁（今天下单明早果园直发）",
//        "goods_id":"162",
//        "img":"upload/2017/11/06/20171106131330863.jpg",
//        "sell_price":"40.00",
//        "market_price":"55.00",
//        "point":"0",
//        "weight":"5000.00",
//        "store_nums":"19911",
//        "exp":"0",
//        "goods_no":"SD150994759218-1",
//        "product_id":"0",
//        "seller_id":"48",
//        "is_delivery_fee":"0",
//        "photo":[
//        {
//        "img":"upload/2017/11/06/20171106131330863.jpg"
//        },
//        {
//        "img":"upload/2017/11/06/20171106131330872.jpg"
//        },
//        {
//        "img":"upload/2017/11/06/20171106131330908.jpg"
//        },
//        {
//        "img":"upload/2017/11/06/20171106131330417.jpg"
//        },
//        {
//        "img":"upload/2017/11/06/20171106131330477.jpg"
//        },
//        {
//        "img":"upload/2017/11/06/20171106131330129.jpg"
//        }
//        ]
//    },
//    "time":1535094555
//}

import Foundation
import SwiftyJSON
//BaseModel
class GoodInfo {
    @objc var name:String = ""//商品名
    @objc var goods_id:Int = 0//商品id
    @objc var img:String = ""//商品图片路径
    @objc var sell_price:String = ""//现价
    @objc var market_price:String = ""//原价
    @objc var point:Int = 0//积分
    @objc var weight:String = ""//重量
    @objc var store_nums:String = ""//库存
    @objc var exp:Int = 0//经验值
    @objc var goods_no:String = ""//商品的货号
    @objc var product_id:String = ""//货号（查询规格）
    @objc var seller_id:String = ""//卖家id
    @objc var is_delivery_fee:Int = 0//是否免运费  0收费 1免费
    var photo:[GoodsPhoto] = [GoodsPhoto]()
    
    init(jsonData:JSON){
        name = jsonData["name"].stringValue
        goods_id = jsonData["goods_id"].intValue
        img = jsonData["img"].stringValue
        sell_price = jsonData["sell_price"].stringValue
        market_price = jsonData["market_price"].stringValue
        point = jsonData["point"].intValue
        weight = jsonData["weight"].stringValue
        store_nums = jsonData["store_nums"].stringValue
        exp = jsonData["exp"].intValue
        goods_no = jsonData["goods_no"].stringValue
        product_id = jsonData["product_id"].stringValue
        seller_id = jsonData["seller_id"].stringValue
        is_delivery_fee = jsonData["is_delivery_fee"].intValue
        for json in jsonData["photo"].arrayValue {
            photo.append(GoodsPhoto(jsonData: json))
        }
    }
}
