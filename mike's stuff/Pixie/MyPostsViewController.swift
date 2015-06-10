
//
//  MyPostsViewController.swift
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
   var posts = [Post]()
   var currentPostIndex: Int!
   let defaults = NSUserDefaults.standardUserDefaults()
   var userId: Int!
   
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
      
      if let savedId = defaults.stringForKey("PixieUserId") {
         userId = savedId.toInt()
      }
      loadPostsFromAPI()
      
      var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
      rightSwipe.direction = .Right
      view.addGestureRecognizer(rightSwipe)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func handleSwipes(sender: UISwipeGestureRecognizer) {
      if sender.direction == .Right {
         self.performSegueWithIdentifier("presentNav", sender: self)
      }
   }
   
   func loadPostsFromAPI() {
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/userPosts/\(userId)"
      
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//         println("loadPostsFromAPI json...\n\(json)")
         if let items = json["results"] as? NSArray {
            for item in items {
               if let start = item["start_name"] as? String {
                  if let startLatStr = item["start_lat"] as? String {
                     let startLat = (startLatStr as NSString).doubleValue
                     if let startLonStr = item["start_lon"] as? String {
                        let startLon = (startLonStr as NSString).doubleValue
                        if let end = item["end_name"] as? String {
                           if let endLatStr = item["end_lat"] as? String {
                              let endLat = (endLatStr as NSString).doubleValue
                              if let endLonStr = item["end_lon"] as? String {
                                 let endLon = (endLonStr as NSString).doubleValue
                                 if let day = item["day"] as? String {
                                    if let time = item["time"] as? String {
                                       if let postId = item["postId"] as? Int {
                                          if let userIdStr = item["userId"] as? String {
                                             let userId = userIdStr.toInt()!
                                             if let driverEnum = item["driver_enum"] as? String {
                                                let isDriver = driverEnum == "DRIVER" ? true : false
                                                let start = Location(name: start, lat: startLat, long: startLon)
                                                let end = Location(name: end, lat: endLat, long: endLon)
                                                self.posts.append(Post(isDriver: isDriver, start: start, end: end, day: day, time: time, postId: postId, userId: userId))
//                                                posts[posts.count-1].toString()
                                             } else {
                                                println("error: driver_enum")
                                             }
                                          } else {
                                             println("error: userId")
                                          }
                                       } else {
                                          println("error: postId")
                                       }
                                    } else {
                                       println("error: time")
                                    }
                                 } else {
                                    println("error: day")
                                 }
                              } else {
                                 println("error: end_lon")
                              }
                           } else {
                              println("error: end_lat")
                           }
                        } else {
                           println("error: end_name")
                        }
                     } else {
                        println("error: start_lon")
                     }
                  } else {
                     println("error: start_lat")
                  }
               } else {
                  println("error: start_name")
               }
            }
         } else {
            println("error: posts")
         }
      } else {
         println("error json: \(error)")
      }
      println()
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return posts.count
   }
   
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyPostsTableViewCell
      let myPost = posts[indexPath.row]
      
      cell.seekOfferLabel.text = myPost.isDriver ? "😎 Offering" : "😊 Seeking"
      cell.locationLabel.text = "\(myPost.start.name) \u{2192} \(myPost.end.name)"
      cell.dateTimeLabel.text = "\(myPost.day), \(myPost.time)"
      
      return cell
   }
   
   func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
      
      var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
         
         let alertController = UIAlertController(title: "Are you sure you want to delete this post?", message: nil, preferredStyle: .Alert)
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
         alertController.addAction(cancelAction)
         
         let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            let post = self.posts[indexPath.row]
            self.posts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/posts/\(post.postId)"
            var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            request.HTTPMethod = "DELETE"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{
               (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
               if let anError = error
               {
                  println("error calling DELETE when deleting postId \(post.postId)")
                  println(anError)
               }
            })
         }
         alertController.addAction(deleteAction)
         
         self.presentViewController(alertController, animated: true, completion: nil)
      })
      
      var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
         tableView.setEditing(false, animated: false)
         self.currentPostIndex = indexPath.row
         self.performSegueWithIdentifier("presentEditPostView", sender: self)
      })
      editAction.backgroundColor = UIColor(red:0.68, green:0.91, blue:0.98, alpha:1.0)
      
      
      return [deleteAction, editAction]
   }
   
   func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      return nil
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "presentNav" {
         let toViewController = segue.destinationViewController as! NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
      else if segue.identifier == "presentEditPostView" {
         let toViewController = segue.destinationViewController as! EditPostViewController
         toViewController.currentPost = posts[currentPostIndex]
         toViewController.currentPostIndex = currentPostIndex
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
   
   @IBAction func unwindToMyPosts(segue:UIStoryboardSegue) {}
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}