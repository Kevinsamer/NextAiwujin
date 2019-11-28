//
//  GoodDetailBaseViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class GoodDetailBaseViewController: UIViewController ,IndicatorInfoProvider{
    var goodsInfo : GoodInfo?
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        //self.goodsInfo = goodsInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemInfo: IndicatorInfo = "View"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        //        view.backgroundColor = UIColor.random.lighten()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
