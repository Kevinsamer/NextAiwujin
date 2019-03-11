//
//  ChannelInfo.swift
//  NextAiwujin
//  热门商品model
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

//"channel_info" =         (
//    {
//        descript = "";
//        id = 10;
//        keywords = "";
//        name = "\U7c73\U9762\U7cae\U6cb9";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 1;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 11;
//        keywords = "";
//        name = "\U9152\U6c34\U8336\U996e";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 2;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 12;
//        keywords = "";
//        name = "\U5e72\U679c\U5e72\U8d27";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 3;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 13;
//        keywords = "";
//        name = "\U74dc\U679c\U852c\U83dc";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 4;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 14;
//        keywords = "";
//        name = "\U679c\U6728\U82b1\U5349";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 5;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 15;
//        keywords = "";
//        name = "\U6d77\U9c9c\U6c34\U4ea7";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 6;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 16;
//        keywords = "";
//        name = "\U9999\U6599\U8c03\U6599";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 7;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 17;
//        keywords = "";
//        name = "\U86cb\U5976\U8089\U79bd";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 8;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 18;
//        keywords = "";
//        name = "\U836f\U98df\U540c\U6e90";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 9;
//        title = "";
//        visibility = 1;
//},
//    {
//        descript = "";
//        id = 19;
//        keywords = "";
//        name = "\U96f6\U98df\U7cd5\U70b9";
//        "parent_id" = 8;
//        "seller_id" = 0;
//        sort = 10;
//        title = "";
//        visibility = 1;
//}
//)

import Foundation

class ChannelInfo:BaseModel {
    @objc var descript:String = ""
    @objc var id:Int = 0
    @objc var keywords:String = ""
    @objc var name:String = ""//分类 name
    @objc var parent_id:Int = 0
    @objc var seller_id:Int = 0
    @objc var sort:Int = 0
    @objc var title:String = ""
    @objc var visibility:Int = 0
//    @objc var img:String = ""//Channel img 路径
//    @objc var gride:Int = 0
}
