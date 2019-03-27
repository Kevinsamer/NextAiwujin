//
//  ChoosTypeTableViewCell.swift
//  NextAiwujin
//  展示规格的cell
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

import UIKit

class ChoosTypeTableViewCell: UITableViewCell {
    var typeView :TypeView!
    var _model : GoodsTypeModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        typeView = TypeView(frame: CGRect(x:0,y:100,width:finalScreenW,height:10))
        addSubview(typeView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(model:GoodsTypeModel) -> CGFloat {
        _model = model
        typeView.initWith(arr: model.typeArray, typeName: model.typeName, index: model.selectIndex)
        return (typeView?.mHeight)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
