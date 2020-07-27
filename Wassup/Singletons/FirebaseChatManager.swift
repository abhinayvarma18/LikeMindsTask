//
//  FirebaseChatManager.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class FirebaseChatManager {
    static let shared = FirebaseChatManager()
    var ref: DatabaseReference! = Database.database().reference()
    func checkIfUserWithPhoneNumberExists(completion:((Bool)->Void)?) {
        let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
        ref.child("Users").child(phoneNumber).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSDictionary {
                completion?(true)
                return
            }
            completion?(false)
            return
        }
    }
    
    func saveUserInfo(name:String,imageUrl:String?) {
        let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
        let userDict = ["name":name, "imageUrl":imageUrl == nil ? "x" : imageUrl]
        ref.child("Users").child(phoneNumber).setValue(userDict)
    }
    
    func getUsers(completion:((Contact?)->Void)?) {
        ref.child("Users").observe(.childAdded) { (snapshot) in
            DatabaseManager.shared.saveUser(key: snapshot.key, dict: snapshot.value as? [String:String] ?? [:],completion: {
                (contact) in
                completion?(contact)
            })
        }
    }
    
    func getChatrooms(completion:((ChatRoom?)->Void)?) {
        let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
        ref.child("UsersChatRooms").child(phoneNumber).observe(.childAdded) {
            (snapshot) in
            let chatroomId = snapshot.key
            let valueDict = (snapshot.value as? [String:String]) ?? [:]
            let chatroomSenderName = valueDict["senderName"] ?? ""
            let chatroomSenderImage = valueDict["senderImage"] ?? ""
            DatabaseManager.shared.saveChatRoom(chatRoomId:chatroomId,senderName:chatroomSenderName,senderImage:chatroomSenderImage)
            self.addValueChangeListnerOnChatRoom(id:chatroomId,completion:completion)
            
        }
    }
    
    func addValueChangeListnerOnChatRoom(id:String,completion:((ChatRoom?)->Void)?) {
        ref.child("ChatRooms").child(id).observe(.value) { (snapshot) in
            let value = snapshot.value as? [String:String] ?? [:]
            let lastMessage = value["lastMessage"] ?? ""
            let lastMessageTimeStamp = value["lastMessageTimeStamp"] ?? ""
            DatabaseManager.shared.updateChatRoom(id:id,lastMessage:lastMessage,lastMessageTimeStamp:lastMessageTimeStamp, completion:{(chatroom) in
                completion?(chatroom)
            })
        }
    }
    
}
