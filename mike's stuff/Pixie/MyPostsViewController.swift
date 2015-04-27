
//
//  MyRidesViewController.swift
//  Pixie
//
//  Created by Nicole on 3/19/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
   
   @IBOutlet weak var navBar: UINavigationBar!
   
   var tableView: UITableView!
   var navTransitionOperator = NavigationTransitionOperator()
   //var posts = [Post]()
   var posts = [Post(start: "start test1", end: "end test1", date: "date test1", time: "test test1", userId: 1), Post(start: "start test2", end: "end test2", date: "date test2", time: "test test2", userId: 1), Post(start: "start test3", end: "end test3", date: "date test3", time: "test test3", userId: 1), Post(start: "start test4", end: "end test4", date: "date test4", time: "test test4", userId: 1), Post(start: "start test5", end: "end test5", date: "date test5", time: "test test5", userId: 1)]
   
   override func loadView() {
      super.loadView()
      
      tableView = UITableView(frame: CGRectZero)
      tableView.dataSource = self
      tableView.delegate = self
      tableView.registerClass(MyPostsTableViewCell.self, forCellReuseIdentifier: "Cell")
      tableView.backgroundColor = UIColor.clearColor()
      tableView.scrollEnabled = true
      tableView.showsVerticalScrollIndicator = true
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 100.0
      tableView.tableFooterView = UIView(frame: CGRectZero)
      tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(tableView)
      
      let viewsDict = ["tableView":tableView, "navBar":navBar]
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[navBar]-0-[tableView]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      //loadPostsFromAPI()
      //tableView.reloadData()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
      rightSwipe.direction = .Right
      view.addGestureRecognizer(rightSwipe)
   }
   
   func handleSwipes(sender: UISwipeGestureRecognizer) {
      if sender.direction == .Right {
         self.performSegueWithIdentifier("presentNav", sender: self)
      }
   }
   
   func loadPostsFromAPI() {
      var myUserId = "2";
      let defaults = NSUserDefaults.standardUserDefaults()
      if let savedId = defaults.stringForKey("PixieUserId") {
         myUserId = savedId;
      }
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/posts"
      
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
         if let items = json["posts"] as? NSArray {
            for item in items {
               if let userId = item["userId"] as? Int {
                  if userId == myUserId.toInt() {
                     if let start = item["start"] as? String {
                        if let end = item["end"] as? String {
                           if let day = item["day"] as? String {
                              if let time = item["time"] as? String {
                                 if let userId = item["userId"] as? Int {
                                    self.posts.append(Post(start: start, end: end, date: day, time: time, userId: userId))
                                 }
                              } else {
                                 println("error: time")
                              }
                           } else {
                              println("error: day")
                           }
                        } else {
                           println("error: end")
                        }
                     } else {
                        println("error: start")
                     }
                  }
               } else {
                  println("error: userId")
               }
            }
         } else {
            println("error: posts")
         }
      } else {
         println("error \(error)") // print the error!
      }
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return posts.count
   }
   
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyPostsTableViewCell
      let myPost = posts[indexPath.indexAtPosition(0)]
      
      cell.locationLabel.text = "\(myPost.startingLoc) \u{2192} \(myPost.endingLoc)"
      cell.dateTimeLabel.text = "\(myPost.date), \(myPost.time)"
      
      return cell
   }
   
   func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
      
      var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
         
         self.posts.removeAtIndex(indexPath.row)
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
         
         //         To-do add api call to delete post from database
      })
      
      var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
         //         To-do add edit post functionality
      })
      
      
      return [deleteAction, editAction]
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "presentNav" {
         let toViewController = segue.destinationViewController as! NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
}
