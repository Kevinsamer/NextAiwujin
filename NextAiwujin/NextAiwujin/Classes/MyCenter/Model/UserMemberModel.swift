//
//  UserMemberModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserMemberModel {
//    var time:String = ""//时间戳
    var result:JSON = JSON()
    @objc var id:Int = 0//用户id
    @objc var username:String = ""//用户名
    @objc var password:String = ""//密码
    @objc var head_ico:String = ""//头像
    @objc var user_id:Int = 0//用户id
    @objc var true_name:String = ""//真实姓名
    @objc var telephone:String = ""//联系电话
    @objc var mobile:String = ""//手机号
    @objc var area:String = ""//地区编码集合  ",130000,130200,130202"  可能有1、2、3个编码
    @objc var contact_addr:String = ""//联系地址
    @objc var qq:String = ""//qq号
    @objc var sex:Int = 1//性别 1男2女
    @objc var birthday:String = ""//生日 "2000-08-31"
    @objc var group_id:Int = 0//分组
    @objc var exp:Int = 0//经验值
    @objc var point:Int = 0//积分
    @objc var message_ids:String = ""//消息id
    @objc var time:String = ""//注册日期时间
    @objc var zip:String = ""//邮编
    @objc var status:Int = 1//用户状态  1正常 2删除至回收站  3锁定
    @objc var prop:String = ""//用户拥有的工具
    @objc var balance:Float = 0.00//余额
    @objc var last_login:String = ""//最后登录时间
    @objc var custom:String = ""//用户习惯方式，配送和支付方式等信息
    @objc var email:String = ""//邮箱
    var local_pd:String = ""
    
    init(jsonData: JSON){
        result = jsonData
        id = result["id"].intValue
        username = result["username"].stringValue
        password = result["password"].stringValue
        head_ico = result["head_ico"].stringValue
        user_id = result["user_id"].intValue
        true_name = result["true_name"].stringValue
        telephone = result["telephone"].stringValue
        mobile = result["mobile"].stringValue
        area = result["area"].stringValue
        contact_addr = result["contact_addr"].stringValue
        qq = result["qq"].stringValue
        sex = result["sex"].intValue
        birthday = result["birthday"].stringValue
        group_id = result["group_id"].intValue
        exp = result["exp"].intValue
        point = result["point"].intValue
        message_ids = result["message_ids"].stringValue
        time = result["time"].stringValue
        zip = result["zip"].stringValue
        status = result["status"].intValue
        prop = result["prop"].stringValue
        balance = result["balance"].floatValue
        last_login = result["last_login"].stringValue
        custom = result["custom"].stringValue
        email = result["email"].stringValue
    }
}
