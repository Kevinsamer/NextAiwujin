//
//  RedditCommentCell.swift
//  Commenting
//
//  Created by Stéphane Sercu on 26/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments
import Kingfisher
import SkeletonView
struct RedditConstants {
    static let sepColor = #colorLiteral(red: 0.9686660171, green: 0.9768124223, blue: 0.9722633958, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.9961144328, green: 1, blue: 0.9999337792, alpha: 1)
    static let commentMarginColor = RedditConstants.backgroundColor
    static let rootCommentMarginColor = #colorLiteral(red: 0.9332661033, green: 0.9416968226, blue: 0.9327681065, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.929128468, green: 0.9298127294, blue: 0.9208832383, alpha: 1)
    static let metadataFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let metadataColor = #colorLiteral(red: 0.6823018193, green: 0.682382822, blue: 0.6822645068, alpha: 1)
    static let textFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let textColor = #colorLiteral(red: 0.4042215049, green: 0.4158815145, blue: 0.4158077836, alpha: 1)
    static let controlsColor = #colorLiteral(red: 0.7295756936, green: 0.733242631, blue: 0.7375010848, alpha: 1)
    static let flashyColor = #colorLiteral(red: 0.1220618263, green: 0.8247511387, blue: 0.7332885861, alpha: 1)
}


class RedditCommentCell: CommentCell {
    open var content:RedditCommentView {
        get {
            return self.commentViewContent as! RedditCommentView
        }
    }
    open var commentContent: String! {
        get {
            return self.content.commentContent
        } set(value) {
            self.content.commentContent = value
        }
    }
    open var posterName: String! {
        get {
            return self.content.posterName
        } set(value) {
            self.content.posterName = value
        }
    }
    open var date: String! {
        get {
            return self.content.date
        } set(value) {
            self.content.date = value
        }
    }
    open var headIconStr: String! {
        get {
            return self.content.headIcnoStr
        } set(value) {
            self.content.headIcnoStr = value
        }
    }
    open var upvotes: Int! {
        get {
            return self.content.upvotes
        } set(value) {
            self.content.upvotes = value
        }
    }
    open var isFolded: Bool {
        get {
            return self.content.isFolded
        } set(value) {
            self.content.isFolded = value
        }
    }
    /// Change the value of the isFolded property. Add a color animation.
    func animateIsFolded(fold: Bool) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.content.backgroundColor = RedditConstants.flashyColor.withAlphaComponent(0.06)
        }, completion: { (done) in
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.content.backgroundColor = RedditConstants.backgroundColor
            }, completion: nil)
        })
        self.content.isFolded = fold
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = RedditCommentView()
        self.backgroundColor = RedditConstants.backgroundColor
        self.commentMarginColor = RedditConstants.commentMarginColor
        self.rootCommentMargin = 1
        self.rootCommentMarginColor = RedditConstants.rootCommentMarginColor
        self.indentationIndicatorColor = RedditConstants.identationColor
        self.commentMargin = 0
        self.isIndentationIndicatorsExtended = true
        self.isSkeletonable = true
//        self.showAnimatedGradientSkeleton()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RedditCommentView: UIView {
    open var commentContent: String! = "content" {
        didSet {
            contentLabel.text = commentContent
        }
    }
    open var posterName: String! = "username" {
        didSet {
            updateUsernameLabel()
        }
    }
    open var headIcnoStr: String! = ""{
        didSet{
            headIcon.kf.setImage(with: URL(string: "\(headIcnoStr!)"), placeholder: UIImage(named: "aiwujin_icon"))
        }
    }
    open var date: String! = "" {
        didSet {
            updateUsernameLabel()
        }
    }
    open var upvotes: Int! = 42 {
        didSet {
            self.upvotesLabel.text = "\(self.upvotes!)"
        }
    }
    open var isFolded: Bool! = false {
        didSet {
            if isFolded {
                fold()
            } else {
                unfold()
            }
        }
    }
    private func updateUsernameLabel() {
        posterLabel.text = "\(self.posterName!) • \(self.date!)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fold() {
        contentHeightConstraint?.isActive = true
        controlBarHeightConstraint?.isActive = true
        controlView.isHidden = true
    }
    private func unfold() {
        contentHeightConstraint?.isActive = false
        controlBarHeightConstraint?.isActive = false
        controlView.isHidden = false
    }
    private var contentHeightConstraint: NSLayoutConstraint?
    private var controlBarHeightConstraint: NSLayoutConstraint?
    
    
    private func setLayout() {
        addSubview(headIcon)
        //        headIcon.translatesAutoresizingMaskIntoConstraints = false
        //        headIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        //        headIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //        headIcon.widthAnchor.constraint(equalToConstant: 40)
        //        headIcon.widthAnchor.constraint(equalToConstant: 40)
        
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: headIcon.leadingAnchor, constant: 10 + headIcon.frame.size.width).isActive = true
        //        posterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        posterLabel.centerYAnchor.constraint(equalTo: headIcon.centerYAnchor, constant: 0).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: posterLabel.leadingAnchor, constant: 0).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        contentLabel.topAnchor.constraint(equalTo: headIcon.bottomAnchor, constant: 3).isActive = true
        contentHeightConstraint = contentLabel.heightAnchor.constraint(equalToConstant: 0)
        //        setupControlView()
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        controlBarHeightConstraint = controlView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    //添加对评论的操作按钮view
    private func setupControlView() {
        let sep1 = UIView()
        sep1.backgroundColor = RedditConstants.sepColor
        //        sep1.isHidden = true
        let sep2 = UIView()
        sep2.backgroundColor = RedditConstants.sepColor
        //        sep2.isHidden = true
        //添加对评论的操作按钮
        controlView.addSubview(downvoteButton)
        controlView.addSubview(upvotesLabel)
        controlView.addSubview(upvoteButton)
        controlView.addSubview(replyButton)
        controlView.addSubview(moreBtn)
        controlView.addSubview(sep1)
        controlView.addSubview(sep2)
        
        
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        sep1.translatesAutoresizingMaskIntoConstraints = false
        sep2.translatesAutoresizingMaskIntoConstraints = false
        
        
        downvoteButton.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -10).isActive = true
        downvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        downvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvotesLabel.trailingAnchor.constraint(equalTo: downvoteButton.leadingAnchor, constant: -10).isActive = true
        upvotesLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvotesLabel.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvoteButton.trailingAnchor.constraint(equalTo: upvotesLabel.leadingAnchor, constant: -10).isActive = true
        upvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep1.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep1.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep1.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep1.trailingAnchor.constraint(equalTo: upvoteButton.leadingAnchor, constant: -10).isActive = true
        
        replyButton.trailingAnchor.constraint(equalTo: sep1.leadingAnchor, constant: -10).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep2.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep2.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep2.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep2.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -10).isActive = true
        
        moreBtn.trailingAnchor.constraint(equalTo: sep2.leadingAnchor, constant: -10).isActive = true
        moreBtn.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        moreBtn.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        moreBtn.leadingAnchor.constraint(equalTo: controlView.leadingAnchor).isActive = true
        
    }
    let controlView = UIView()
    let moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "mre").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        btn.isHidden = true
        return btn
    }()
    let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Reply", for: .normal)
        btn.setTitleColor(RedditConstants.controlsColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.setImage(#imageLiteral(resourceName: "exprt").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        btn.isHidden = true
        return btn
    }()
    let upvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "upvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        btn.isHidden = true
        return btn
    }()
    let upvotesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = RedditConstants.controlsColor
        lbl.text = "42"
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lbl.isHidden = true
        return lbl
    }()
    let downvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "downvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        btn.isHidden = true
        return btn
    }()
    let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "评论内容"
        lbl.textColor = RedditConstants.textColor
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = RedditConstants.textFont
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.clipsToBounds = true
        lbl.isSkeletonable = true
//        lbl.showAnimatedGradientSkeleton()
        return lbl
    }()
    let posterLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 50, y: 10, width: finalScreenW - 60, height: 30))
        lbl.text = "用户名"
        lbl.textColor = RedditConstants.metadataColor
        lbl.font = RedditConstants.metadataFont
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        lbl.clipsToBounds = true
        lbl.isSkeletonable = true
//        lbl.showAnimatedGradientSkeleton()
        return lbl
    }()
    let headIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        //        image.frame.size = CGSize(width: 40, height: 40)
//        image.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.isSkeletonable = true
//        image.showAnimatedGradientSkeleton()
        return image
    }()
    
    public func hideMySkeleton() {
        headIcon.hideSkeleton()
//        posterLabel.hideSkeleton()
//        contentLabel.hideSkeleton()
    }
    
    public func showMySkeleton(){
        headIcon.showAnimatedGradientSkeleton()
//        posterLabel.showAnimatedGradientSkeleton()
//        contentLabel.showAnimatedGradientSkeleton()
    }
    
}
