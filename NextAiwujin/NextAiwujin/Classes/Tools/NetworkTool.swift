//
//  NetworkTool.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

//全站搜索接口
/*1.先传搜索关键词，拿到搜索结果id
  2.通过搜索结果id查找搜索结果
*/
///搜索id接口
/// - Parameters:
///   - keyboard:String  搜索关键词
///   - page:String  分页数
///   - show:String  网页展示内容
///   - tempid:String
///   - classid:String
let API_SearchID = "https://click.wjyanghu.com/e/search/i.php"

///新闻数据接口
let API_ConfigFile = "http://www.wjyanghu.com/API/AppConfig_v2.html"
///直播回看数据接口
//let API_ZhiBoHistory = "http://www.wjyanghu.com/API/backtosee.html"
let API_ZhiBoHistory = "http://tp.wjyanghu.com/zbhk/json.php"
///评论数据接口
let API_Comments = "http://tp.wjyanghu.com/zbhk/comments/comments.php"
///发表评论接口{content="评论内容",nickname="用户名",headimg="头像链接"}
let API_CommitComments = "https://tp.wjyanghu.com/zbhk/comments/commit_comments.php"
///爱武进用户头像
let AiWuJinHeadIconUrl = "http://tp.wjyanghu.com/zbhk/images/logo.png"
///分享页面(传4个参数：title,body,img,url)
let SharePageUrl = "https://videoshare.applinzi.com/share.php"

///报料测试服务器地址
let BAOLIAO_URL = "http://192.168.208.105:5555/"

///编辑爆料
//参数名       必选     类型       说明
//id          是      int       新闻id
//address     否      string    地址
//file_ids    否      string    文件id
//content     否      string    新闻内容
let EDIT_REPORT_NEWS_URL = BAOLIAO_URL + "home/account/api?act=editReportNews"

///提交爆料
//参数名    必选    类型    说明
//id       是      int    爆料id
let EDIT_NEWS_STATES_URL = BAOLIAO_URL + "home/account/api?act=editNewsState"

///爆料详情
//参数名    类型    说明      是否必填
//id       int    爆料id    是
let REPORT_NEWS_DETAIL_URL = BAOLIAO_URL + "home/account/api?act=reportNewsDetail"

///新增爆料
//参数名        必选    类型       说明
//content      是      string    爆料内容
//address      是      string    地址
//file_ids     否      string    文件id（多个文件用,隔开 如””0834c17095,68f569059a”）
let ADD_REPORT_NEWS_URL = BAOLIAO_URL + "home/account/api?act=addReportNews"

///上传文件
let UPLOAD_FILES_URL = BAOLIAO_URL + "home/account/api?act=uploadFiles"

///删除爆料
//参数名    必选    类型    说明
//id       是      int    新闻id
let DEL_REPORT_NEWS_URL = BAOLIAO_URL + "home/account/api?act=delReportNews"

///爆料列表
let REPORT_NEWS_LIST_URL = BAOLIAO_URL + "home/account/api?act=reportNewsList"


///测试服务器地址
//let BASE_URL = "http://192.168.108.223/"
///发布服务器地址
let BASE_URL = "https://shop.wjyanghu.com/"

//-----以下接口分为测试版和正式版
//-----测试版
//let HOMEDATA_URL = BASE_URL + "app/home"//首页数据接口
//let GOODINFO_URL = BASE_URL + "app/goodinfo"//商品详情数据库接口,传商品id
//let GOODPRODUCT_URL = BASE_URL + "app/getSpecification"//规格接口,传商品id
//let SEARCH_URL = BASE_URL + "app/getSearch"//搜索接口 传搜索内容和分页数,价格上下限(min_price/max_pirce:Int)
//let CATEGORYLIST_URL = BASE_URL + "app/getGoodslist"//分类搜索结果  传分类id和分页数
//let CATEGORYS_URL = BASE_URL + "app/typeleft"//分类数据接口  可选参数父分类id
//let LOGIN_URL = BASE_URL + "app/login_act"//登录接口
//let REGISTER_URL = BASE_URL + "app/reg_act"//注册接口
//let CARTINFO_URL = BASE_URL + "app/cart"//购物车数据接口
//let GETADDRESS_URL = BASE_URL + "app/getaddress"//得到用户所有地址，传id(user_id)
//let ISDEFAULTADDRESS_URL = BASE_URL + "app/getDefaultaddress"//获得用户默认地址接口,传递用户id
/////预览订单数据接口(购物车整体结算传值为is_phone=true,商品单个结算时传值增加id:商品id或者货品id,type:goods或者product,num:购买数量)
//let PREVIEWORDER_URL = BASE_URL + "simple/cart2"
////let PREVIEWORDER_URL = BASE_URL + "iosapp/cart2"//正式版接口地址
/////提交订单数据接口
//let POSTORDER_URL = BASE_URL + "simple/cart3"
////let POSTORDER_URL = BASE_URL + "iosapp/cart3"//正式版接口地址
/////我的订单数据接口(传用户id 分页数)
//let MYORDERLIST_URL = BASE_URL + "app/getOrderList"
/////订单商品列表接口(传订单id,is_send 0未发货  1已发货)
//let ORDERGOODS_URL = BASE_URL + "app/iosgetordergoods"
/////订单详情接口(传订单id，is_phone)
//let ORDERDETAIL_URL = BASE_URL + "ucenter/order_detail"
/////修改订单状态接口，(传订单id和status)
//let UPDATEORDER_URL = BASE_URL + "app/updateOrder"
/////修改密码接口(传原密码、新密码、重复新密码)
//let PASSWORDEDIT_URL = BASE_URL + "app/password_edit"
/////修改资料接口
//let INFOEDITACT_URL = BASE_URL + "app/info_edit_act"
/////用户资料接口
//let MYINFO_URL = BASE_URL + "app/my_info"

//-----正式版
let HOMEDATA_URL = BASE_URL + "app/home"//首页数据接口
let GOODINFO_URL = BASE_URL + "iosapp/goodinfo"//商品详情数据库接口,传商品id
let GOODPRODUCT_URL = BASE_URL + "iosapp/getSpecification"//规格接口,传商品id
let SEARCH_URL = BASE_URL + "iosapp/getSearch"//搜索接口 传搜索内容和分页数,价格上下限(min_price/max_pirce:Int)
let CATEGORYLIST_URL = BASE_URL + "iosapp/getGoodslist"//分类搜索结果  传分类id和分页数
let CATEGORYS_URL = BASE_URL + "iosapp/typeleft"//分类数据接口  可选参数父分类id
let LOGIN_URL = BASE_URL + "iosapp/login_act"//登录接口
let REGISTER_URL = BASE_URL + "iosapp/reg_act"//注册接口
let CARTINFO_URL = BASE_URL + "iosapp/cart"//购物车数据接口
let GETADDRESS_URL = BASE_URL + "iosapp/getaddress"//得到用户所有地址，传id(user_id)
let ISDEFAULTADDRESS_URL = BASE_URL + "iosapp/getDefaultaddress"//获得用户默认地址接口,传递用户id
///预览订单数据接口(购物车整体结算传值为is_phone=true,商品单个结算时传值增加id:商品id或者货品id,type:goods或者product,num:购买数量)
let PREVIEWORDER_URL = BASE_URL + "iosapp/cart2"
//let PREVIEWORDER_URL = BASE_URL + "iosapp/cart2"//正式版接口地址
///提交订单数据接口
let POSTORDER_URL = BASE_URL + "iosapp/cart3"
//let POSTORDER_URL = BASE_URL + "iosapp/cart3"//正式版接口地址
///我的订单数据接口(传用户id 分页数)
let MYORDERLIST_URL = BASE_URL + "iosapp/getOrderList"
///订单商品列表接口(传订单id,is_send 0未发货  1已发货)
let ORDERGOODS_URL = BASE_URL + "iosapp/iosgetordergoods"
///订单详情接口(传订单id，is_phone)
let ORDERDETAIL_URL = BASE_URL + "iosapp/order_detail"
///修改订单状态接口，(传订单id和status)
let UPDATEORDER_URL = BASE_URL + "iosapp/updateOrder"
///修改密码接口(传原密码、新密码、重复新密码)
let PASSWORDEDIT_URL = BASE_URL + "iosapp/password_edit"
///修改资料接口
let INFOEDITACT_URL = BASE_URL + "iosapp/info_edit_act"
///用户资料接口
let MYINFO_URL = BASE_URL + "iosapp/my_info"

//------以下调用原生或添加对应服务器代码即可
let GOODWEBDETAIL_URL = BASE_URL + "siteapp/productsapp/id/"//图文详情接口，直接拼接商品id
let LOGINOUT_URL = BASE_URL + "simple/logout"//退出登录接口
let AUTHCODE_URL = BASE_URL + "site/getCaptcha/random"//验证码图片链接
let JOINCART_URL = BASE_URL + "simple/joinCart"//传id(商品或货品),数量,类型(goods/product)
let REMOVECART_URL = BASE_URL + "simple/removeCart"//传id(商品或货品),类型(goods/product)
let DEFAULTADDRESS_URL = BASE_URL + "ucenter/address_default"//设置默认地址接口,传地址id
let DELADDRESS_URL = BASE_URL + "ucenter/address_del"//删除地址接口,传地址id
let ADDADDRESS_URL = BASE_URL + "simple/address_add"//添加地址接口
///根据省份名获取省份id的接口，传省份名
let SEARCHPROVINCE_URL = BASE_URL + "block/searchProvince"
///获得配送方式
let ORDERDELIVERY_URL = BASE_URL + "block/order_delivery"
///订单取消|确认收货接口（传订单id，op:cancel/confirm）
let ORDERSTATUS_URL = BASE_URL + "ucenter/order_status"
///支付宝支付字符串接口(传body,subject,out_trade_no,total_amount)
let ZFBPAYSTRING_URL = "https://zfbtest.applinzi.com/index.php"

//-----待使用
///评论数据接口
let COMMENTS_URL = BASE_URL + "comment_ajax"//?goods_id=1&page=1

enum MethodType {
    case GET
    case POST
}

class NetworkTool{
    class func requestData(type : MethodType, urlString : String, parameters : [String : NSString]? = nil, finishCallback : @escaping (_ result : Any) -> ()){
        //1.判断请求方法
        let method = type == .GET ? Alamofire.HTTPMethod.get : Alamofire.HTTPMethod.post
        //2.发送请求
        AF.request(urlString, method: method, parameters: parameters).responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments) { (response) in
            switch response.result {
            case .success:
                guard let result = response.data else {
                    print("成功，但是封装后网络数据解析出现错误error:\(String(describing: response.data))\(urlString)")
                    return
                }
                finishCallback(result as Any)
                break
                
            case .failure:
                print("失败且封装后网络数据解析出现错误error:\(String(describing: response.data?.string(encoding: String.Encoding.utf8)))\(urlString)")
                break
            }
        }
    }
    
    /// 发送基于json数据的网络请求
    /// - Parameters:
    ///   - type: .post    .get
    ///   - urlString: 请求链接
    ///   - parameters: let para : [String:String]= ["id":"1","content":"111"]
    ///   - finishCallback: 回调函数
    class func requestDataByJSON<Parameters: Encodable>(type : MethodType, urlString : String, parameters : Parameters? = nil, finishCallback : @escaping (_ result : Any) -> ()){
        //1.判断请求方法
        let method = type == .GET ? Alamofire.HTTPMethod.get : Alamofire.HTTPMethod.post
        //2.发送请求
        AF.request(urlString, method: method, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments) { (response) in
            switch response.result {
            case .success:
                guard let result = response.data else {
                    print("成功，但是封装后网络数据解析出现错误error:\(String(describing: response.data))\(urlString)")
                    return
                }
                finishCallback(result as Any)
                break
                
            case .failure:
                print("失败且封装后网络数据解析出现错误error:\(String(describing: response.data?.string(encoding: String.Encoding.utf8)))\(urlString)")
                break
            }
        }
        
        
//        AF.request(urlString, method: method, parameters: parameters).responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments) { (response) in
//            switch response.result {
//            case .success:
//                guard let result = response.data else {
//                    print("成功，但是封装后网络数据解析出现错误error:\(String(describing: response.data))")
//                    return
//                }
//                finishCallback(result as Any)
//                break
//
//            case .failure:
//                print("失败且封装后网络数据解析出现错误error:\(String(describing: response.data?.string(encoding: String.Encoding.utf8)))")
//                break
//            }
//        }
    }
    
    
    /// 上传文件
    /// - Parameters:
    ///   - fileUrl: 文件url，URL
    ///   - toUrl: 服务器url，String
    ///   - finishCallback: 回调函数
    class func uploadFiles(fileUrl: URL, toUrl: String, finishCallback: @escaping (_ result: Any)->()){
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileUrl, withName: "filename")
        }, to: toUrl)
            .uploadProgress(closure: { (progress) in
                //上传进度
//                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON { (response) in
            switch response.result {
            case .success:
                guard let result = response.data else {
                    print("成功，但是封装后网络数据解析出现错误error:\(String(describing: response.data))\(toUrl)")
                    return
                }
//                print("上传成功")
                finishCallback(result as Any)
                break
                
            case .failure:
                print("失败且封装后网络数据解析出现错误error:\(String(describing: response.data?.string(encoding: String.Encoding.utf8)))\(toUrl)")
                break
            }
        }
    }
}

