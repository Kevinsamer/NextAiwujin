//
//  NetworkTool.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import Alamofire

//服务器地址
//测试服务器地址
//let BaseURL:String = ""
//生产服务器地址
//let BaseURL:String = ""

//接口列表

enum MethodType {
    case GET
    case POST
}

class NetworkTool{
    class func requestData(type : MethodType, urlString : String, parameters : [String : NSString]? = nil, finishCallback : @escaping (_ result : Any) -> ()){
        //1.判断请求方法
        let method = type == .GET ? Alamofire.HTTPMethod.get : Alamofire.HTTPMethod.post
        //2.发送请求
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                guard let result = response.result.value else {
                    //3.错误处理
                    print("error:\(response.result.error ?? "出现错误" as! Error )")
                    return
                }
                //4.结果返回
                finishCallback(result as Any)
            }else{
                print("error:\(response.result.error ?? "出现错误" as! Error )")
            }
            
        }
    }
}

