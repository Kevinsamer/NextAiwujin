//
//  Area.swift
//  NextAiwujin
//  地区信息类
//  Created by DEV2018 on 2019/3/12.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

class Area:Decodable {
    @objc var area_id:String = ""//地区id
    @objc var parent_id:String = ""//上一级的id值
    @objc var area_name:String = ""//地区名称
    @objc var sort:String = ""//排序 = 地区id
}
