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
    
    var bubbleImageOutgoing: JSQMessagesBubbleImage!
    var bubbleImageIncoming: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var messages: [JSQMessage]!
        
        var bubbleFactory = JSQMessagesBubbleImageFactory()
        bubbleImageOutgoing = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red: 0.0, green: 256/188, blue: 256/209, alpha: 1.0))
        bubbleImageIncoming = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
}