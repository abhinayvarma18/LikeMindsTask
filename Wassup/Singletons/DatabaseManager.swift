//
//  DatabaseManager.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var managedObjectContext:NSManagedObjectContext?
    let userEntity:NSEntityDescription?
    let chatroomEntity:NSEntityDescription?
    let messageEntity:NSEntityDescription?
    
    init() {
         managedObjectContext = delegate?.persistentContainer.viewContext
         userEntity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext!)
         chatroomEntity = NSEntityDescription.entity(forEntityName: "ChatRoom", in: managedObjectContext!)
         messageEntity = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext!)
    }
    
    func saveUser(key:String,dict:[String:String], completion:((Contact?)->Void?)) {
        if !checkIfUserExist(phone: key) {
            let user = NSManagedObject(entity: userEntity!, insertInto: managedObjectContext)
            user.setValue(dict["imageUrl"] ?? "noimage", forKey: "imageUrl")
            user.setValue(dict["name"] ?? "name", forKey: "name")
            user.setValue(key, forKey: "phone")
            do {
                try managedObjectContext?.save()
                completion(user as? Contact)
            } catch {
                print("could not save . \(error), \(error.localizedDescription) ")
            }
        }
    }
    
    private func checkIfUserExist(phone:String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "phone = %@", phone)
        do {
            if let fetchResults = try managedObjectContext!.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    return true
                }
            }
        }catch {
            
        }
        
        return false
    }
    
    func getContacts() -> [Contact] {
        managedObjectContext = delegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            let result = try managedObjectContext?.fetch(fetchRequest)
            return result as? [Contact] ?? []
        }catch {
            return []
        }
    }
    
    private func checkIfChatroomExist(chatroom:String) -> Bool {
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatRoom")
           fetchRequest.predicate = NSPredicate(format: "chatRoomId = %@", chatroom)
           do {
               if let fetchResults = try managedObjectContext!.fetch(fetchRequest) as? [NSManagedObject] {
                   if fetchResults.count != 0{
                       return true
                   }
               }
           }catch {
               
           }
           
           return false
       }
    
    func saveChatRoom(chatRoomId:String,senderName:String,senderImage:String) {
        if(!checkIfChatroomExist(chatroom:chatRoomId)) {
            let chatroom = NSManagedObject(entity: chatroomEntity!, insertInto: managedObjectContext)
            chatroom.setValue(senderName, forKey: "senderName")
            chatroom.setValue(senderImage, forKey: "senderImage")
            chatroom.setValue(chatRoomId, forKey: "chatRoomId")
            do {
                try managedObjectContext?.save()
            } catch {
                print("could not save . \(error), \(error.localizedDescription) ")
            }
        }
    }
    
    func updateChatRoom(id:String,lastMessage:String,lastMessageTimeStamp:Int64, completion:((ChatRoom?)->Void)?) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatRoom")
        fetchRequest.predicate = NSPredicate(format: "chatRoomId = %@", id)
        do {
            if let fetchResults = try managedObjectContext!.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(lastMessage, forKey: "lastMessage")
                    managedObject.setValue(lastMessageTimeStamp, forKey: "lastMessageTimeStamp")
                    completion?(managedObject as? ChatRoom)
                    try managedObjectContext?.save()
                }
            }
        } catch {
            
        }
    }
    
    func saveMessagesForChatRoom(chatRoomId:String,dict:[String:Any], completion:((Message)->Void)?) {
        let message = NSManagedObject(entity: messageEntity!, insertInto: managedObjectContext)
        message.setValue(dict["body"] as? String ?? "", forKey: "messageBody")
        message.setValue(dict["sentBy"] as? String ?? "", forKey: "sentBy")
        message.setValue(dict["timeStamp"] as? Int64 ?? 0, forKey: "messageTimeStamp")
        message.setValue(chatRoomId, forKey: "chatroomId")
            
        do {
            try managedObjectContext?.save()
            completion?(message as! Message)
        } catch {
            print("could not save . \(error), \(error.localizedDescription) ")
        }
    }
    
    func checkIfChatExists(imageUrl:String) -> (Bool,String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatRoom")
        fetchRequest.predicate = NSPredicate(format: "senderImage = %@", imageUrl)
        do {
            if let fetchResults = try managedObjectContext!.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    return (true,(fetchResults[0] as? ChatRoom)?.chatRoomId)
                }
            }
        }catch {
            
        }
        
        return (false,nil)
    }
    
}
