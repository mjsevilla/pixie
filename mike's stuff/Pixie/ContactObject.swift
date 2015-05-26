//
//  ContactObject.swift
//  Pixie
//
//  Created by Mike Sevilla on 5/20/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class ContactObject {
    var name: String?
    var id: String?
    
    init(_id: String) {
        let urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users/\(_id)"
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)! as NSData
        
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            let first = json["first_name"] as! String
            let last = json["last_name"] as! String
            name = "\(first) \(last)"
            println("name: \(name)")
        }
        
        self.id = _id
    }
}