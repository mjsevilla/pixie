//
//  MessageCell.swift
//  Pixie
//
//  Created by Mike Sevilla on 4/29/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var convoID: String?
    var convo: PFObject?
}