//
//  NavigationViewController.swift
//  Pixie
//
//  Created by Mike Sevilla on 2/22/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var tableView   : UITableView!
    @IBOutlet var dimmerView  : UIView!
    
    var items : [NavigationModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        bgImageView.image = UIImage(named: "nav-bg")
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        let item1 = NavigationModel(title: "SeARCH", icon: "location")
        let item2 = NavigationModel(title: "MY PROFILe", icon: "user")
        let item3 = NavigationModel(title: "PAYMeNTS", icon: "wallet")
        let item4 = NavigationModel(title: "MeSSAGeS", icon: "icon-chat", count: "3")
        let item5 = NavigationModel(title: "PAST RIDeS", icon: "car")
        let item6 = NavigationModel(title: "MY FAVORITeS", icon: "icon-star")
        let item7 = NavigationModel(title: "SeTTINGS", icon: "icon-filter")
        let item8 = NavigationModel(title: "ABOUT", icon: "icon-info")
        let item9 = NavigationModel(title: "SIGN OUT", icon: "door")
        
        items = [item1, item2, item3, item4, item5, item6, item7, item8, item9]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as NavigationCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.countLabel.text = item.count
        cell.iconImageView.image = UIImage(named: item.icon)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

class NavigationModel {
    
    var title : String!
    var icon : String!
    var count : String?
    
    init(title: String, icon : String) {
        self.title = title
        self.icon = icon
    }
    
    init(title: String, icon : String, count: String) {
        
        self.title = title
        self.icon = icon
        self.count = count
    }
}
