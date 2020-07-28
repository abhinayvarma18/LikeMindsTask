//
//  ChatMessagesViewController.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit
import SDWebImage

class ChatMessagesViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var chatMessagesTableView: UITableView!
    
    @IBOutlet weak var textMessageTextField: UITextField!
    
    let userName = UserDefaults.standard.value(forKey: "name") as? String
    
    var chatroom:ChatRoom? {
        didSet {
            chatroomId = chatroom?.chatRoomId
        }
    }
    
    var messages:[Message] = []
    
    var chatroomId:String? {
        didSet {
            getMessages()
        }
    }
    var sender:Contact? {
        didSet {
          
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        textMessageTextField.delegate = self
        updateProfileImageAndName()
        bottomView.layer.cornerRadius = 10.0
    }
    
    private func updateProfileImageAndName() {
        senderImageView.layer.masksToBounds = false
        senderImageView.layer.cornerRadius = senderImageView.frame.size.height/2
        senderImageView.clipsToBounds = true
        if let url = URL(string: chatroom?.senderImage ?? "") {
            senderImageView.sd_setImage(with: url, completed: nil)
            senderName.text = chatroom?.senderName
        }else {
            if let url = URL(string: sender?.imageUrl ?? "") {
                senderImageView.sd_setImage(with: url, completed: nil)
                senderName.text = sender?.name
            }else {
                senderImageView.image = UIImage(named: "defaultProfilePhoto")
            }
        }
    }
    
    private func setupTableView() {
        let imageView = UIImageView(image: UIImage(named: "bgChatroom"))
        imageView.bounds = self.view.bounds
        chatMessagesTableView.backgroundView = imageView
        chatMessagesTableView.separatorStyle = .none
        chatMessagesTableView.delegate = self
        chatMessagesTableView.dataSource = self
        chatMessagesTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "receiverCell")
        chatMessagesTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderCell")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        textMessageTextField.resignFirstResponder()
        return true
    }
    
    private func sendMessage() {
        self.resignFirstResponder()
        if !(textMessageTextField.text?.isEmpty ?? true) {
            if chatroomId == nil {
                //create a chatroom
                FirebaseChatManager.shared.initiateChatroomNodes(contact: sender!, message: textMessageTextField.text ?? "", completion: {[weak self](chatroomId) in
                    self?.chatroomId = chatroomId
                })
            }else {
                //send message
                FirebaseChatManager.shared.sendMessageOnExistingChatroom(chatroomId: chatroomId!, message:textMessageTextField.text! , userName: userName ?? "")
            }
            textMessageTextField.text = ""
        }else {
            //please enter a valid message
        }
    }
    
    func getMessages() {
        FirebaseChatManager.shared.getMessagesForChatRoom(chatroomId: chatroomId!) { [weak self](message) in
            self?.messages.append(message)
            self?.reorderMessages()
            self?.chatMessagesTableView.reloadData()
        }
    }
    
    func reorderMessages() {
        self.messages = self.messages.sorted(by: { $0.messageTimeStamp < $1.messageTimeStamp })
    }
    
}

extension ChatMessagesViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.sentBy == userName {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as? ReceiverTableViewCell
            cell?.updateCellContent(message:message)
            return cell ?? UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderTableViewCell
        cell?.updateCellContent(message:message)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.messages.count - 1 {
            DispatchQueue.main.async {
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

