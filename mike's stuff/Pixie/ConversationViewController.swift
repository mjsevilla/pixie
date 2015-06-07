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
    var messages: [JSQMessage] = []
    let user = PFUser.currentUser()!
    var recipientName: String?
    var recipientId: String?
    var convoId: String?
    var convo: PFObject?
    var fromMatches: Bool?
    var bubbleImageOutgoing: JSQMessagesBubbleImage!
    var bubbleImageIncoming: JSQMessagesBubbleImage!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        user.fetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.senderId = user["userId"] as! String
        super.senderDisplayName = user["name"] as! String
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        showTypingIndicator = true
        showLoadEarlierMessagesHeader = true
        self.collectionView.loadEarlierMessagesHeaderTextColor = UIColor(red: 0/256, green: 188/256, blue: 209/256, alpha: 1.0)
        self.collectionView.typingIndicatorMessageBubbleColor = UIColor.jsq_messageBubbleLightGrayColor()
        navigationItem.title = recipientName!
        if self.fromMatches == true {
            let backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "callUnwindMatches:")
            backBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: .Normal)
            navigationItem.leftBarButtonItem = backBtn
        }
        
        spinner.center = CGPointMake(self.view.frame.midX, self.view.frame.midY)
        self.collectionView.addSubview(spinner)
        self.view.addSubview(spinner)
        
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0/256, green: 188/256, blue: 209/256, alpha: 1.0)
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        inputToolbar.contentView.leftBarButtonItem = nil
        
        bubbleImageOutgoing = bubbleFactory.outgoingMessagesBubbleImageWithColor(uicolorFromHex(0x00BCD1))
        bubbleImageIncoming = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        self.loadMessages()
    }
    
    func callUnwindMatches(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("unwindMatches", sender: self)
    }
    
    func uicolorFromHex(rgbValue:UInt32) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    // load previous messages of a convo
    func loadMessages() {
        var lastMsg = messages.last
        var query = PFQuery(className: "Message")
        
        // sort w/ newest at bottom
        query.whereKey("convoId", equalTo: convoId!)
        if lastMsg != nil {
            query.whereKey("createdAt", greaterThanOrEqualTo: lastMsg!.date)
        }
        query.limit = 20
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    self.newMessage(object as! PFObject, ndx: 0)
                }
                if self.messages.count != 0 {
                    self.automaticallyScrollsToMostRecentMessage = true
                    self.finishReceivingMessage()
                }
                // Scroll to bottom if a new message has been recieved
                if objects!.count > 0 {
                    self.scrollToBottomAnimated(true)
                }
            }
            else {
                println("Error retrieving messages: \(error)")
            }}
    }
    
    // load earlier messages when button is hit
    func loadEarlierMessages() {
        var oldestMsg = messages[0]
        var query = PFQuery(className: "Message")
        
        query.whereKey("convoId", equalTo: convoId!)
        query.whereKey("createdAt", lessThan: oldestMsg.date)
        query.limit = 20
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    self.newMessage(object as! PFObject, ndx: 0)
                }
                if self.messages.count != 0 {
                    self.automaticallyScrollsToMostRecentMessage = false
                    self.finishReceivingMessage()
                }
                // Scroll to bottom if a new message has been recieved
                if objects!.count > 0 {
                    self.scrollToBottomAnimated(true)
                }
            }
            else {
                println("Error loading earlier messages: \(error)")
            }
        }
    }
    
    // add message to message array
    func newMessage(object: PFObject, ndx: Int) {
        var senderId = object["userId"] as! String
        var senderName = object["userName"] as! String
        var text = object["message"] as! String
        var message = JSQMessage(senderId: senderId, senderDisplayName: senderName, date: object.createdAt, text: text)
        
        messages.insert(message, atIndex: ndx)
    }
    
    // send message to parse
    func sendMessage(text: String) {
        var parseMsg = PFObject(className: "Message")
        
        parseMsg["userId"] = self.user["userId"] as! String
        parseMsg["userName"] = self.user["name"] as! String
        parseMsg["convo"] = self.convo!
        parseMsg["convoId"] = self.convoId!
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
        self.sendMessage(text)
        self.finishSendingMessage()
        let userQuery = PFUser.query()
        userQuery?.whereKey("userId", equalTo: recipientId!)
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey("user", matchesQuery: userQuery!)
        let pushNot = PFPush()
        pushNot.setQuery(pushQuery)
        pushNot.setData([
            "sound" : "alert.caf",
            "alert" : "\(senderDisplayName) sent you a message",
            "badge" : "Increment",
            "convo" : convo!,
            "cID"   : convoId!,
            "rName" : recipientName!,
            "rID"   : recipientId!
            ])
        pushNot.sendPushInBackgroundWithBlock({ (succeeded, e) -> Void in
            if succeeded {
                println("Push notification sent successfully!")
            }
            if let error = e {
                println("Error: \(error.localizedDescription)")
            }
        })
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.startAnimating()
            })
            
            self.loadEarlierMessages()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.stopAnimating()
            })
        })
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
        
        let attributes: [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
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
            return CGFloat(0.0)
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0)
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // handles hiding keyboard when user touches outside of keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.collectionView.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
