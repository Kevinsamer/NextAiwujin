//
//  SelectedProduct.swift
//  NextAiwujin
//  选择的商品规格和数量、、、、如果该商品没有规格，则记录商品信息和数量
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

class SelectedProduct {
    var good_Id:Int?
    var selectedProduct:GoodsProduct?
    var selectedNum:Int?
    ///规格类型  0无规格  1有规格
    var productType:Int?
}
