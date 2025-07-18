//
//  MyAreaPickerView.swift
//  GetArea
//
//  Created by DEV2018 on 2018/8/21.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
let KeyWindow = UIApplication.shared.keyWindow ?? (UIApplication.shared.delegate as! AppDelegate).window
let pickerViewBtnW: CGFloat = 100.0
let pickerViewBtnH: CGFloat = 50.0
class MyAreaPickerView: UIControl {
    var areas:[Area] = Areas
    var provinces:[Area] = [Area]()
    var citys:[Area] = [Area]()
    var towns:[Area] = [Area]()
    var selectProvince:Area?
    var selectCity:Area?
    var selectTwon:Area?
    
    typealias SelectCityHandle = ((Area, Area, Area) -> ())?
    
    private var selectCityHandle: SelectCityHandle
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: picker.frame.width - pickerViewBtnW, y: 0, width: pickerViewBtnW, height: pickerViewBtnH)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: 0, y: 0, width: pickerViewBtnW, height: pickerViewBtnH)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        return button
    }()
    
//    lazy var shadowView: UIControl = {
//        let view = UIControl(frame: UIScreen.main.bounds)
//        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
//        //        view.alpha = 0.5
//        view.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
//        return view
//    }()
    
    lazy var picker: UIPickerView = {
        let pick = UIPickerView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 300))
        pick.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pick.delegate = self
        pick.dataSource = self
        return pick
    }()
    
    lazy var popView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 350))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    init(selectCityHandle: SelectCityHandle) {
        
        self.selectCityHandle = selectCityHandle
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        initData()
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyAreaPickerView{
    func initViews(){
        popView.addSubview(cancelButton)
        popView.addSubview(doneButton)
        popView.addSubview(picker)
        addSubview(popView)
    }
    
    func initData(){
//        areas = getDataFromTxt()!
        for area in areas {
            if area.parent_id == "\(0)" {
                //print(area.area_name)
                provinces.append(area)
                //print(provinces.count)
            }
        }
        for area in areas {
            if area.parent_id == provinces[0].area_id {
                citys.append(area)
            }
        }
        for area in areas {
            if area.parent_id == citys[0].area_id {
                towns.append(area)
            }
        }
    }
    
//    static func showChooseCityView(level: Int = 3, defaultAddress: (String?,String?,String?)? = nil,  selectCityHandle: SelectCityHandle){
//        let view = AreaPickView(level: level, defaultAddress: defaultAddress, selectCityHandle: selectCityHandle)
//
//        SJKeyWindow?.addSubview(view)
//        UIView.animate(withDuration: 0.4) {
//            view.subviews[0].frame.origin.y -= view.subviews[0].size.height
//        }
//    }
    
    static func showAreaPickerView(selectCityHandle: SelectCityHandle) {
        let pickerView = MyAreaPickerView(selectCityHandle: selectCityHandle)
        KeyWindow?.addSubview(pickerView)
        UIView.animate(withDuration: 0.2) {
            pickerView.popView.frame.origin.y -= 350
        }
        
    }
    
    static func getDataFromTxt() -> [Area]?{
        let path = Bundle.main.path(forResource: "iwebshop_areas", ofType: "txt")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
//            let data = NSData.init(contentsOfFile: path)
            let models = try JSONDecoder().decode([Area].self, from: data)
            
            //print("models:\(models)")
            return models
        } catch {
            print("解析失败")
            return nil
        }
    }
    
    static func getAreaNameByID(id:String)->String{
        var temp = ""
        for area in Areas{
            if area.area_id == id {
                temp = area.area_name
            }
        }
        return temp
    }
    
    @objc func doneBtnClick(){
        if let block = selectCityHandle {
            selectProvince = provinces[picker.selectedRow(inComponent: 0)]
            if citys.count != 0 {
                selectCity = citys[picker.selectedRow(inComponent: 1)]
            }else{ selectCity = Area() }
            if towns.count != 0 {
                selectTwon = towns[picker.selectedRow(inComponent: 2)]
            }else{ selectTwon = Area() }
            //print("\(selectProvince?.area_name ?? "")+\(selectCity?.area_name ?? "")+\(selectTwon?.area_name ?? "")")
            block(selectProvince!, selectCity!, selectTwon!)
            selectCityHandle = nil
            selectProvince = nil
            selectCity = Area()
            selectTwon = Area()
            cancelBtnClick()
        }
    }
    
    @objc func cancelBtnClick(){
        UIView.animate(withDuration: 0.2, animations: {
            self.popView.frame.origin.y += 350
        }) { [unowned self] (bool)  in
            self.removeFromSuperview()
        }
    }
}

extension MyAreaPickerView:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //列数
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //每列行数
        let provinceNum = provinces.count
        let cityNum = citys.count
        let townNum = towns.count
        
        return [provinceNum, cityNum, townNum][component]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //每行的值
        if component == 0 {
            return provinces[row].area_name
        }else if component == 1 {
            return citys[row].area_name
        }else {
            return towns[row].area_name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //选择某行后刷新数据
        if component == 0 {
            citys.removeAll()
            for area in areas {
                if area.parent_id == provinces[row].area_id {
                    citys.append(area)
                    //                    print(area.area_name)
                    //                    print(citys.count)
                }
            }
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            towns.removeAll()
            for area in areas {
                if citys.count != 0 && area.parent_id == citys[0].area_id {
                    towns.append(area)
                }
            }
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if component == 1{
            towns.removeAll()
            for area in areas {
                if citys.count != 0 && area.parent_id == citys[row].area_id {
                    
                    towns.append(area)
                }
            }
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return finalScreenW * 0.3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.textAlignment = .center
            pickerLabel?.numberOfLines = 0
            pickerLabel?.backgroundColor = YTools.randomColorIn(colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)])
            
        }
        if component == 0 {
            pickerLabel?.text = provinces[row].area_name
        }else if component == 1, citys.count != 0 {
            pickerLabel?.text = citys[row].area_name
        }else if component == 2, towns.count != 0 {
            pickerLabel?.text = towns[row].area_name
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
}
