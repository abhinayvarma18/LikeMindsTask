//
//  ChatListingViewController.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class ChatListingViewController: UIViewController {

    @IBOutlet weak var chatListTableView: UITableView!
    var chatrooms:[ChatRoom] = [] {
        didSet {
            chatListTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        getChatRooms()
    }
    
    private func getChatRooms() {
        FirebaseChatManager.shared.getChatrooms(completion:{[weak self](chatroom) in
            if chatroom != nil {
                if let index = self?.getIndexOfChatroom(id:chatroom!.chatRoomId ?? "") {
                    self?.chatrooms[index] = chatroom!
                } else {
                    self?.chatrooms.append(chatroom!)
                }
            }
        })
    }
    
    func getIndexOfChatroom(id:String) -> Int? {
        for index in 0..<chatrooms.count {
            if chatrooms[index].chatRoomId == id {
                return index
            }
        }
        return nil
    }
    
    private func setupTableView() {
        chatListTableView.separatorStyle = .none
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRoomCell")
        chatListTableView.reloadData()
    }
    

    @IBAction func onClickAddContact(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: VCStoryBoardIds.newContact) as? NewContactViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension ChatListingViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as? ChatRoomTableViewCell
        let chatroom = chatrooms[indexPath.row]
        cell?.updateCell(chatroom: chatroom)
        return cell ?? UITableViewCell()
    }
}
