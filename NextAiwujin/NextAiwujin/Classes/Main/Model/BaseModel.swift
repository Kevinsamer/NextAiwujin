//
//  BaseModel.swift
//  NextAiwujin
//  Model基类
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

class BaseModel:NSObject {
    
    init(dict:[String: NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("有未解析json数据,key=\(key)")
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        if !keyedValues.isEmpty {
            super.setValuesForKeys(keyedValues)
        }
    }
    
    override func setNilValueForKey(_ key: String) {
        print(key)
    }
    
}
