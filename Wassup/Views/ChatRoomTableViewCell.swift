//
//  ChatRoomTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(chatroom:ChatRoom) {
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
        nameLabel.text = chatroom.senderName
        messageLabel.text = chatroom.lastMessage
        timeLabel.text = chatroom.lastMessageTimeStamp
    }
    
}
