//
//  MessagesViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 4/29/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewContoller: UITableViewController {
    var navTransitionOperator = NavigationTransitionOperator()
    var userID: String?
    var userName: String?
    var convos: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.delegate = self
        tableView.dataSource = self
        convos = []
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.performSegueWithIdentifier("presentNav", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadConversations()
    }
    
    // load all conversations that have the user's ID
    func loadConversations() {
        var query1 = PFQuery(className: "Conversation")
        query1.whereKey("user1Id", equalTo: userID!)
        var query2 = PFQuery(className: "Conversation")
        query2.whereKey("user2Id", equalTo: userID!)
        
        var query = PFQuery.orQueryWithSubqueries([query1, query2])
        query.orderByDescending("updatedAt")
        query.includeKey("lastMessage")
        
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects, error) -> Void in
            if error == nil {
                self.convos!.removeAll(keepCapacity: true)
                for object in objects! {
                    self.convos!.append(object as! PFObject)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func goBackToMessagesView(segue:UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as! NavigationViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.navTransitionOperator
            toViewController.presentingView = self
        }
        if segue.identifier == "presentConvo" {
            if let destVC = segue.destinationViewController as? ConversationViewController {
                let cell = sender as! MessageCell
                
                destVC.userName = self.userName
                destVC.userId = self.userID
                destVC.recipientName = cell.nameLabel.text
                destVC.convoId = cell.convoID
                destVC.convo = cell.convo
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MessageCell
        cell.convo = convos![indexPath.row]
        performSegueWithIdentifier("presentConvo", sender: cell)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // swipe to remove conversations
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            convos?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convos!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let convo = convos![indexPath.row]
        let user1 = convo["user1Id"] as! String
        let user2 = convo["user2Id"] as! String
        let recipientName = (self.userID == user1 ? convo["user2Name"] : convo["user1Name"]) as? String
        let lastMsgObj = convo["lastMessage"] as? PFObject
        let lastMsg = lastMsgObj!["message"] as! NSString
        
        // cut off last message preview if it's too long
        if lastMsg.length > 47 {
            let shortMsg = lastMsg.substringWithRange(NSRange(location: 0, length: 47)) + "..."
            cell.lastMessageLabel.text = shortMsg
        }
        else {
            cell.lastMessageLabel.text = lastMsg as String
        }
        cell.nameLabel.text = recipientName
        cell.timestampLabel.text = getTimestamp(convo, lastMsg: lastMsgObj)
        cell.convoID = convo.objectId
        
        return cell
    }
    
    func getTimestamp(convo: PFObject, lastMsg: PFObject?) -> String {
        var date = convo.createdAt
        var lastMsgDate = lastMsg!.createdAt
        if lastMsgDate != nil {
            date = lastMsgDate
        }
        var time = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(date)
        
        if (time == "Today") {
            time = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(date)
        }
        else if (time != "Yesterday") {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            time = formatter.stringFromDate(date!)
        }
        
        return time
    }
}

