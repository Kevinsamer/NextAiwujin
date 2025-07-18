//
//  OrderViewModel.swift
//  NextAiwujin
//  订单viewModel
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit
class OrderViewModel{
    
}

extension OrderViewModel{
    ///请求配送方式
    /// - parameter goodsList:商品数组，用于拼接请求链接
    /// - parameter province:省份代码
    /// - parameter finishCallback:回调函数
    func requestOrderDelivery(goodsList:[ShopCartGoodsModel], province:String,  finishCallback:@escaping (_ kuaiDi:OrderDeliveryModel, _ ziTi:OrderDeliveryModel)->()){
        var url = "\(ORDERDELIVERY_URL)?province=\(province)"
        for goods in goodsList{url += "&goodsId%5B%5D=\(goods.goods_id)"}
        for goods in goodsList{url += "&productId%5B%5D=\(goods.product_id)"}
        for goods in goodsList{url += "&num%5B%5D=\(goods.count)"}
        //        print("url:\(url)")
        NetworkTool.requestData(type: MethodType.GET, urlString: url) { (result) in
            //print("result:\(result)")
            let resultJson = JSON(result)
            //print(resultJson)
            let kuaidi = OrderDeliveryModel(jsonData: resultJson["1"])
            let ziti = OrderDeliveryModel(jsonData: resultJson["3"])
            //            print(kuaidi.name)
            //            print(ziti.name)
            finishCallback(kuaidi, ziti)
        }
    }
    ///根据省份名请求省份id,某些情况会导致地址信息中存储的省市区编号为空，则省市区名也为空，此时向该接口传递的是一个空值，接口会强制返回北京市的编码110000，导致在无省分名称数据的情况下查询到省份id，所以如果传递的省份名时空值，则传值固定为"nil"
    /// - parameter name:省份名
    /// - parameter finishCallback:回调函数
    /// - parameter provinceID:请求到的省份id
    func requestProvinceIDByName(provinceName name:String, finishCallback:@escaping (_ provinceID:String)->()){
        NetworkTool.requestData(type: .POST, urlString: SEARCHPROVINCE_URL, parameters: ["province":"\(name == "" ? "nil" : name)" as NSString]) { (result) in
            let resultJSON = JSON(result)
            //let flag = resultJSON["flag"].stringValue
            let id = resultJSON["area_id"].stringValue
            finishCallback(id)
            
        }
    }
    ///请求预览订单数据:如果是购物车全部结算则不传id、type、num
    /// - parameter isPhone:判断是否为请求result数据的标签位,true则返回生成预览订单的json
    /// - parameter id:商品id,如果有规格则为货品id
    /// - parameter type:商品类型，goods或product
    /// - parameter num:购买数量
    /// - parameter finishCallback:回调函数
    /// - parameter sum:商品总价
    /// - parameter goodsLists:预览订单的商品列表
    /// - parameter tax:税费
    func requestPreviewOrder(isPhone:String, id:String? = nil, type:String? = nil, num:String? = nil, finishCallback:@escaping (_ sum:Double, _ goodsLists:[ShopCartGoodsModel], _ tax:Double)->()){
        NetworkTool.requestData(type: .POST, urlString: PREVIEWORDER_URL, parameters: ["is_phone":"\(isPhone)" as NSString, "id":"\(id ?? "")" as NSString, "type":"\(type ?? "")" as NSString, "num":"\(num ?? "")" as NSString]) { (result) in
            let resultJSON = JSON(result)
            let goodsTotalPrice:Double = resultJSON["sum"].doubleValue
            var goodsList:[ShopCartGoodsModel] = [ShopCartGoodsModel]()
            for goodsJson in resultJSON["goodsList"].arrayValue{
                goodsList.append(ShopCartGoodsModel(jsonData: goodsJson))
            }
            let goodsTax:Double = resultJSON["tax"].doubleValue
            finishCallback(goodsTotalPrice, goodsList, goodsTax)
        }
    }
    
    ///请求提交订单数据,分为单独商品提交和购物车一起提交
    /// - parameter isPhone:判断是否为请求result数据的标签位,true则返回生成预览订单的json
    /// - parameter directGid:如果是购物车全部结算，传0；如果是单个商品，传goodsid或者productId
    /// - parameter directType:商品类型，如果购物车全部结算则不传；如果是单个商品，传goods或者product（对应directGid）
    /// - parameter directNum:购买数量，如果是购物车全部结算则传1；如果是单个商品则传对应的数量
    /// - parameter directPromo:未知参数，暂不使用
    /// - parameter directActiveId:未知参数，传0
    /// - parameter acceptTime:收货时间，默认使用"任意"
    /// - parameter payment:支付方式id，1位预付款支付，10为app拉起支付宝支付，14为app拉起微信支付,暂时默认只能使用支付宝支付
    /// - parameter message:订单留言
    /// - parameter taxes:税费
    /// - parameter taxTitle:发票抬头
    /// - parameter radioAddress:收货地址id
    /// - parameter deliveryId:配送方式id(1为快递配送，3位自提)
    func requestPostOrder(isPhone:String, directGid:Int, directType:String? = nil, directNum:Int, directPromo:String? = nil, directActiveId:Int = 0, acceptTime:String = "任意", payment:Int = 10, message:String, taxes:Double? = nil, taxTitle:String? = nil, radioAddress:Int, deliveryId:Int, finishCallback:@escaping (_ postOrderBackModel:PostOrderResultModel)->()){
        NetworkTool.requestData(type: MethodType.POST, urlString: POSTORDER_URL, parameters: ["is_phone":"\(isPhone)" as NSString, "direct_gid":"\(directGid)" as NSString, "direct_type":"\(directType ?? "")" as NSString, "direct_num":"\(directNum)" as NSString, "direct_promo":"\(directPromo ?? "")" as NSString, "direct_active_id":"\(directActiveId)" as NSString, "accept_time":"任意" as NSString, "payment":"\(payment)" as NSString, "message":"\(message)" as NSString, "taxes":"\(taxes ?? 0)" as NSString, "radio_address":"\(radioAddress)" as NSString, "delivery_id":"\(deliveryId)" as NSString, "tax_title":"\(taxTitle ?? "")" as NSString]) { (result) in
            //print(result)
            let resultJson = JSON(result)
            let resultModel = PostOrderResultModel(jsonData: resultJson)
            finishCallback(resultModel)
        }
    }
    //原生网站的支付回调请求链接
    //    http://192.168.108.223/block/callback/_id/9?
    //    buyer_email=13160107520
    //    &buyer_id=2088602259945606
    //    &exterface=create_direct_pay_by_user
    //    &is_success=T
    //    &notify_id=RqPnCoPT3K9%252Fvwbh3Ihy93vQ4hks4slosF%252F0Yri1XVIEaBT5l26zbOpbAoOmcQC6Fyr0
    //    &notify_time=2018-12-10+10%3A49%3A39
    //    &notify_type=trade_status_sync
    //    &out_trade_no=20181210103637984578
    //    &payment_type=1
    //    &seller_email=18006126885%40189.cn
    //    &seller_id=2088721058126224
    //    &subject=%E9%A3%A8%E5%AE%B6
    //    &total_fee=0.11
    //    &trade_no=2018121022001445601016680522
    //    &trade_status=TRADE_SUCCESS
    //    &sign=53d69c0f599f9392943d5d3a4f0bf368
    //    &sign_type=MD5
    
    ///网站原生调起支付方法接口，app无法使用,请调用支付宝sdk的方法调起支付宝
    /// - parameter orderId:接收订单id数组，处理为id_id_id_id的字符串
    /// - parameter paymentId:支付方式id,暂时默认为支付宝支付
//    @available(iOS,deprecated: 1.0)
//    func requestDoPay(orderId:[Int], paymentId:Int, finishCallback:@escaping ()->()){
//        var orderIds:String = "\(orderId[0])"
//        if orderId.count > 1 {
//            for i in 1..<orderId.count{
//                orderIds += "_\(orderId[i])"
//            }
//        }
//        NetworkTool.requestData(type: .POST, urlString: DOPAY_URL, parameters: ["payment_id":"\(paymentId)" as NSString, "order_id":"\(orderIds)" as NSString]) { (result) in
//            finishCallback()
//        }
//        
//    }
    
    ///更新订单状态接口
    /// - parameter id:订单id
    /// - parameter status:订单状态id  1生成订单----2支付订单----3取消订单(客户触发)----4作废订单(管理员触发)----5完成订单----6退款(订单完成后)----7部分退款(订单完成后)
    /// - parameter pay_status:支付状态id  0未支付  1已支付
    func requestUpdateOrder(order_id id:Int, status:Int, pay_status:Int, finishCallback:@escaping (_ updateResult:Bool)->()){
        NetworkTool.requestData(type: .POST, urlString: UPDATEORDER_URL, parameters: ["id":"\(id)" as NSString, "status":"\(status)" as NSString, "pay_status":"\(pay_status)" as NSString]) { (result) in
            let json = JSON(result)
            //print(json)
            if json["code"].intValue == 200 {
                finishCallback(true)
            }else{
                finishCallback(false)
            }
        }
    }
    
    /// 请求支付宝支付字符串
    ///
    /// - Parameters:
    ///   - body: 对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
    ///   - subject: 商品的标题/交易标题/订单标题/订单关键字等。
    ///   - out_order_no: 商户网站唯一订单号
    ///   - total_amount: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
    ///   - finishCallback: 回调函数
    func requestZFBString(body:String, subject:String, out_order_no:String, total_amount:String, finishCallback:@escaping (_ zfbString:String)->()){
        //        NetworkTools.requestData(type: .POST, urlString: ZFBPAYSTRING_URL, parameters: ["body":"\(body)" as NSString, "subject":"\(subject)" as NSString, "out_trade_no":"\(out_order_no)" as NSString, "total_amount":"\(total_amount)" as NSString]) { (result) in
        //            print(result)
        //        }
        
        AF.request(ZFBPAYSTRING_URL, method: .post, parameters: ["body":"\(body)" as NSString, "subject":"\(subject)" as NSString, "out_trade_no":"\(out_order_no)" as NSString, "total_amount":"\(total_amount)" as NSString]).responseString { (result) in
            if let result = result.value{
                finishCallback(result)
            }
        }
        
    }
}
