//
//  ProgramListCell.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/5/28.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ProgramListCell: UITableViewCell {

    @IBOutlet var liveTagLabel: UILabel!
    @IBOutlet var playIngTagLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var playingTabIV: UIImageView!
    @IBOutlet var programNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            liveTagLabel.isHidden = true
            playingTabIV.isHidden = false
            playIngTagLabel.isHidden = false
            startTimeLabel.textColor = .red
            programNameLabel.textColor = .red
        }else{
            playingTabIV.isHidden = true
            playIngTagLabel.isHidden = true
            startTimeLabel.textColor = .black
            programNameLabel.textColor = .black
        }
        // Configure the view for the selected state
    }
    
}
