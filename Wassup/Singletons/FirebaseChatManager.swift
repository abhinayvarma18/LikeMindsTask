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
    
    //login user
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
    
    //Chatroom implementation
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
            let value = snapshot.value as? [String:Any] ?? [:]
            let lastMessage = value["lastMessage"] as? String ?? ""
            let lastMessageTimeStamp = value["lastMessageTimeStamp"] as? Int64 ?? 0
            DatabaseManager.shared.updateChatRoom(id:id,lastMessage:lastMessage,lastMessageTimeStamp:lastMessageTimeStamp, completion:{(chatroom) in
                completion?(chatroom)
            })
        }
    }
    
    //messages chatroom
    func initiateChatroomNodes(contact:Contact, message:String, completion:((String)->Void)?) {
        let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
        let userChatRoomRef = ref.child("UsersChatRooms").child(phoneNumber)
        let nodeToSave = ["senderName":contact.name,"senderImage":contact.imageUrl]
        let newRef = userChatRoomRef.childByAutoId()
        newRef.setValue(nodeToSave)
        let chatroomId = newRef.key
        
        let userName = UserDefaults.standard.value(forKey: "name") as? String ?? ""
        let userImage = UserDefaults.standard.value(forKey: "image") as? String ?? ""
        
        let nodeToSaveInReciptent = ["senderName":userName,"senderImage":userImage]
        ref.child("UsersChatRooms").child(contact.phone!).child(chatroomId!).setValue(nodeToSaveInReciptent)
        
        let chatroomNode:[String:Any] = ["lastMessage": message,"lastMessageTimeStamp":Date().toMillis()!]
        ref.child("ChatRooms").child(chatroomId!).setValue(chatroomNode)
        
        let messagesNode = ref.child("Messages")
        let messageNode = messagesNode.child(chatroomId!).childByAutoId()
        let messageNodeToSave:[String:Any] = ["body":message,"sentBy":userName, "timeStamp":Date().toMillis()!]
        messageNode.setValue(messageNodeToSave)
        completion?(chatroomId ?? "")
    }
    
    func getMessagesForChatRoom(chatroomId:String,completion:((Message)->())?) {
        ref.child("Messages").child(chatroomId).observe(.childAdded) { (snapshot) in
            let messageValue = snapshot.value as? [String:Any] ?? [:]
            DatabaseManager.shared.saveMessagesForChatRoom(chatRoomId: snapshot.key, dict: messageValue) { (message) in
                completion?(message)
            }
        }
    }
    
    func sendMessageOnExistingChatroom(chatroomId:String,message:String,userName:String) {
        let messagesNode = ref.child("Messages")
        let messageNode = messagesNode.child(chatroomId).childByAutoId()
        let messageNodeToSave:[String:Any] = ["body":message,"sentBy":userName, "timeStamp":Date().toMillis()!]
        messageNode.setValue(messageNodeToSave)
        
        DatabaseManager.shared.saveMessagesForChatRoom(chatRoomId: chatroomId, dict: messageNodeToSave) { (message) in
        }
        
        let chatroomNode:[String:Any] = ["lastMessage": message,"lastMessageTimeStamp":Date().toMillis()!]
        ref.child("ChatRooms").child(chatroomId).setValue(chatroomNode)
    }
    
}
