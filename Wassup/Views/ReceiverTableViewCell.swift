//
//  ReceiverTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 28/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        bubbleView.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCellContent(message:Message) {
        self.messageLabel.text = message.messageBody
        self.timeLabel.text = String(message.messageTimeStamp)
    }
}
