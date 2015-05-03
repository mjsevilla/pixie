//
//  MessagesViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 4/29/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var messagesTable: UITableView!
    var navTransitionOperator = NavigationTransitionOperator()
    var messages: [MessageModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        messagesTable.delegate = self
        messagesTable.dataSource = self
        
        let temp = MessageModel(name: "Julio Coolio", lastMsg: "hella long message that will be cut off at the end with triple dots")
        messages = [temp]
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.performSegueWithIdentifier("presentNav", sender: self)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            messages.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let message = messages[indexPath.row]
        
        
        cell.nameLabel.text = message.name
        if count(message.lastMsg) > 50 {
            let lastMsg = message.lastMsg as NSString
            let shortMsg = lastMsg.substringWithRange(NSRange(location: 0, length: 50)) + "..."
            cell.lastMessageLabel.text = shortMsg
        }
        else {
            cell.lastMessageLabel.text = message.lastMsg
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

class MessageModel {
    
    var name: String!
    var lastMsg: String!
    var timestamp: String?
    
    init(name: String, lastMsg: String, timestamp: String) {
        self.name = name
        self.lastMsg = lastMsg
        self.timestamp = timestamp
    }
    
    init(name: String, lastMsg: String) {
        self.name = name
        self.lastMsg = lastMsg
    }
}