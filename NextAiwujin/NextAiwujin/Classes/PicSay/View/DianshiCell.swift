//
//  DianshiCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
class DianshiCell: UITableViewCell {
    var cellHeight:CGFloat = 0
    var isPlayer:Bool = false{
        didSet{
            if !oldValue{
                if isPlayer{
                    //通过CAGradientLayer设置iamgeV的底部渐变色
                    let topColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    let buttomColor = UIColor.black
                    let gradientColors = [topColor.cgColor, buttomColor.cgColor]
                    let gradientLayer = CAGradientLayer()
                    //cell高度为100，imageV上下间距各10，imageV高度为80，以此设定gradientLayer.frame
                    
                    gradientLayer.frame = CGRect(x: 0, y: (cellHeight - 20)/2, width: finalScreenW / 3, height: (cellHeight - 20)/2)
                    gradientLayer.colors = gradientColors
                    //imageV.layer.addSublayer(gradientLayer)
                    //也可以这样：
                    imageV.layer.insertSublayer(gradientLayer, at: 0)
                    //cell上添加遮盖view
                    self.addSubview(alphaView)
                    //添加播放提示小圆点
                    self.addSubview(playingPoint)
                    playingPoint.snp.makeConstraints { (make) in
                        make.centerY.equalToSuperview()
                        make.left.equalToSuperview().offset(5)
                        make.width.height.equalTo(5)
                    }
                    playingPoint.layer.cornerRadius = 2.5
                    self.imageV.addSubview(timeLabel)
                    timeLabel.snp.makeConstraints { (make) in
                        make.left.equalToSuperview()
                        make.right.equalToSuperview().offset(-3)
                        make.bottom.equalToSuperview().offset(-3)
                        make.height.equalTo(17)
                    }
                }
            }
            
        }
    }
    @IBOutlet var updateTimeLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    ///遮盖view
    lazy var alphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: cellHeight))
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3941299229)
        return view
    }()
    ///正在播放标志点
    lazy var playingPoint: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        imageV.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    ///图片底部遮盖view
    lazy var imageBottomView: UIView = {
        let view = UIView()
        //定义渐变的颜色（从黄色渐变到橙色）
        let topColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let buttomColor = UIColor.black
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ///通过Nib初始化cell时调用awakeFromNib方法，通过codes初始化cell时调用initWithCode或者initWithFrame方法
        ///在awakeFromNib方法中无法接收到tableView代理方法中传来的数据，此时可以使用属性监听器didSet监听cell中的该数据，接收到后再进行相关操作
        //添加视频时长接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(getTotalTime(notification:)), name: NSNotification.Name.init(rawValue: "getNowPlayPositionTimeAndVideoDuration"), object: nil)
        //图片加圆角
    }
    
    @objc func getTotalTime(notification:Notification){
        let time = notification.object as! String
        timeLabel.text = time
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isPlayer{
            if selected{
                //选中后隐藏遮盖view，显示播放标志点，图片添加边框,图片上显示总时长
                timeLabel.text = ""
                imageV.layer.borderWidth = 2
                alphaView.isHidden = true
                playingPoint.isHidden = false
                timeLabel.isHidden = false
            }else{
                //未选中显示遮盖view，隐藏播放标志点，图片去除边框，图片上隐藏总时长
                imageV.layer.borderWidth = 0
                alphaView.isHidden = false
                playingPoint.isHidden = true
                timeLabel.isHidden = true
            }
            self.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
            lineView.isHidden = true
            nameLabel.textColor = .white
            
        }
        // Configure the view for the selected state
    }
    
    
    
    
}
