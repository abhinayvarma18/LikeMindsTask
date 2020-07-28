//
//  NewContactTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit
import SDWebImage

class NewContactTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = (profileImageView.bounds.size.width)/2.0
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(contact:Contact) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phone
        let placeHolderImage = UIImage(named: "defaultProfilePhoto")
        if let url = URL(string: contact.imageUrl ?? "") {
            profileImageView.sd_setImage(with: url, placeholderImage: placeHolderImage, options: SDWebImageOptions(rawValue: 3), context: nil)
        }else {
            profileImageView.image = placeHolderImage
        }
    }
    
}
