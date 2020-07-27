//
//  NewContactTableViewCell.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class NewContactTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(contact:Contact) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phone
    }
    
}
