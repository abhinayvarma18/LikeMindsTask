//
//  ChatRoomTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit
import SDWebImage

class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(chatroom:ChatRoom) {
        nameLabel.text = chatroom.senderName
        messageLabel.text = chatroom.lastMessage
        timeLabel.text = String(chatroom.lastMessageTimeStamp)
        let placeHolderImage = UIImage(named: "defaultProfilePhoto")
        if let url = URL(string: chatroom.senderImage ?? "") {
            profileImageView.sd_setImage(with: url, placeholderImage: placeHolderImage, options: SDWebImageOptions(rawValue: 3), context: nil)
        }else {
            profileImageView.image = placeHolderImage
        }
    }
    
}
