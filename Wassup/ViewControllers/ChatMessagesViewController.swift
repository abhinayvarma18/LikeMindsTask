//
//  ChatMessagesViewController.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ChatMessagesViewController: UIViewController {
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderName: NSLayoutConstraint!
    
    @IBOutlet weak var chatMessagesTableView: UITableView!
    
    @IBOutlet weak var textMessageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
