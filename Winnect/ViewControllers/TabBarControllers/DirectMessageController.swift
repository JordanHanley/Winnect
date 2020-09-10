//
//  DirectMessageController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/29/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView

class DirectMessageController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    
    var currentUser: Sender?
    var messagedUser: Sender?
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        loadChatHistory()

    }
    
    
    
    func loadChatHistory(){
        let db = Firestore.firestore()
        let storageRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("dmConversations").document(messagedUser!.senderId).collection("messages")
        storageRef.getDocuments(){(snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            else{
                for document in snapshot!.documents{
                    let text = document.get("text") as? String
                    let timeStamp = document.get("timeStamp") as? Double
                    let docID = document.documentID
                    let wasSent = document.get("wasSent") as? Bool
                    var sender: Sender
                    if wasSent!{
                        sender = self.currentUser!
                    }
                    else {sender = self.messagedUser!}
                    
                    let date = Date(timeIntervalSince1970: timeStamp!)
                    
                    let message = Message(sender: sender, messageId: docID, sentDate: date, kind: .text(text!))
                    
                    if self.messages.count == 0{
                        self.messages.append(message)
                    }
                    else{
                        var index = 0
                        for msg in self.messages{
                            if timeStamp! < msg.sentDate.timeIntervalSince1970{
                                self.messages.insert(message, at: index)
                                break
                            }
                            else{
                                if index+1 == self.messages.count{
                                    self.messages.append(message)
                                }
                            }
                            index += 1
                        }
                    }
                    
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
    
    func currentSender() -> SenderType {
        return currentUser!
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let db = Firestore.firestore()
        var storageRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("dmConversations").document(messagedUser!.senderId).collection("messages")
        let docID = storageRef.document().documentID
        let date = Date()
        storageRef.document(docID).setData(["timeStamp":date.timeIntervalSince1970, "text":text, "wasSent":true]) {(error) in
            if (error != nil){return}
            else{
                storageRef = db.collection("users").document(self.messagedUser!.senderId).collection("dmConversations").document(Auth.auth().currentUser!.uid).collection("messages")
                storageRef.document(docID).setData(["timeStamp":date.timeIntervalSince1970, "text":text, "wasSent":false]) {(error) in
                    if (error != nil) {return}
                    else{
                        
                    }
                }
                
                let message = Message(sender: self.currentUser!, messageId: docID, sentDate: date, kind: .text(text))
                self.messages.append(message)
                inputBar.inputTextView.text = ""
                self.messagesCollectionView.reloadData()
                print(Date().timeIntervalSince1970)
                print(self.messages.count)
            }
        }
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        if (((message.sender) as! Sender).pfp == nil){
            avatarView.image = UIImage(named: "DefaultProfilePicture")
        }
        else{
            avatarView.image = (message.sender as! Sender).pfp
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if(message.sender.senderId == self.currentUser!.senderId){
            return UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        }
        else {return UIColor.init(red: 230/255, green: 230/255, blue: 235/255, alpha: 1)}
    }
    
}



struct Sender: SenderType{
    var senderId: String
    var displayName: String
    var pfp: UIImage?
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
