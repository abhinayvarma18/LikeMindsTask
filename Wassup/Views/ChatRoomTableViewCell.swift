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
        let placeHolderImage = UIImage(named: "defaultProfilePhoto")
        if let url = URL(string: chatroom.senderImage ?? "") {
            profileImageView.sd_setImage(with: url, placeholderImage: placeHolderImage, options: SDWebImageOptions(rawValue: 3), context: nil)
        }else {
            profileImageView.image = placeHolderImage
        }
        let timeString = getTimeFromTimeStamp(timestamp: chatroom.lastMessageTimeStamp)
        timeLabel.text = timeString
    }
    
    func getTimeFromTimeStamp(timestamp:Int64) -> String {
        let todaydate = Date()
        let todayDate = todaydate.get(.day)
        
        let date = Date(timeIntervalSince1970: Double(timestamp/1000))
        let messageDate = date.get(.day)
        let dateFormatter = DateFormatter()
        if messageDate == todayDate {
            //show in form of hours
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.dateStyle = .none //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            return localDate
        }else if todayDate - messageDate == 1 {
            return "Yesterday"
        }
        
        dateFormatter.timeStyle = .none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
}
