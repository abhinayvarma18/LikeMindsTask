//
//  SenderTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 28/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        bubbleView.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCellContent(message:Message) {
           self.messageTextLabel.text = message.messageBody
           self.timeLabel.text = String(message.messageTimeStamp)
    }
    
}
