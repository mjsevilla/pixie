//
//  ConversationViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 5/2/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: JSQMessagesViewController {
    var messages: [JSQMessage]!
    var userId: String?
    var userName: String?
    var recipientName: String?
    
    var convoId: String?
    var convo: PFObject?

    var bubbleImageOutgoing: JSQMessagesBubbleImage!
    var bubbleImageIncoming: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.senderId = userId
        super.senderDisplayName = userName
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        automaticallyScrollsToMostRecentMessage = true
        messages = []
        self.navigationItem.title = recipientName!
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0/256, green: 188/256, blue: 209/256, alpha: 1.0)
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        bubbleImageOutgoing = bubbleFactory.outgoingMessagesBubbleImageWithColor(uicolorFromHex(0x00BCD1))
        bubbleImageIncoming = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        loadMessages()
    }
    
    func uicolorFromHex(rgbValue:UInt32) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    // load previous messages of a convo
    func loadMessages() {
        var lastMsg = messages.last
        var query = PFQuery(className: "Message")
        
        //
        query.whereKey("convoId", equalTo: convoId!)
        if lastMsg != nil {
            query.whereKey("createdAt", greaterThan: lastMsg!.date)
        }
        
        // sort w/ newest at bottom
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if error == nil {
                self.automaticallyScrollsToMostRecentMessage = true
                for object in objects! {
                    self.newMessage(object as! PFObject)
                }
                
                if self.messages.count != 0 {
                    self.finishReceivingMessage()
                }
                
                // Scroll to bottom if a new message has been recieved
                if objects!.count > 0 {
                    self.scrollToBottomAnimated(true)
                }
            }
            else {
                println("Error retrieving messages")
            }}
    }
    
    // add message to message array
    func newMessage(object: PFObject) {
        var senderId = object["userId"] as! String
        var senderName = object["userName"] as! String
        var text = object["message"] as! String
        var message = JSQMessage(senderId: senderId, senderDisplayName: senderName, date: object.createdAt, text: text)
        
        messages.append(message)
    }
    
    // send message to parse
    func sendMessage(text: String) {
        var parseMsg = PFObject(className: "Message")
        
        parseMsg["userId"] = self.userId
        parseMsg["userName"] = self.userName
        parseMsg["convoId"] = self.convoId
        parseMsg["message"] = text
        
        parseMsg.saveInBackgroundWithBlock {
            [unowned self] (success: Bool, error: NSError?) -> Void in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.convo!["lastMessage"] = parseMsg
                self.convo!.saveInBackground()
                self.loadMessages()
            }
            else {
                println("Error: Message could not send")
            }
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        sendMessage(text)
        finishSendingMessage()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId != self.senderId {
            // incoming message
            cell.textView.textColor = UIColor.blackColor()
        }
        else {
            // outgoing message
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return bubbleImageOutgoing
        }
        
        return bubbleImageIncoming
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == self.senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}
