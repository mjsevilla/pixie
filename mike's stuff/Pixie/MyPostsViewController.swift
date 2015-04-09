
//
//  MyRidesViewController.swift
//  Pixie
//
//  Created by Nicole on 3/19/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MyPostsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {
   
   @IBOutlet weak var navBar: UINavigationBar!
   
   var collectionView: UICollectionView!
   var navTransitionOperator = NavigationTransitionOperator()
   var posts = [Post]()
   
   override func loadView() {
      super.loadView()
      
      var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: view.frame.width, height: 60)
      layout.scrollDirection = .Vertical
      layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
      
      collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.registerClass(MyPostsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
      collectionView.backgroundColor = UIColor.clearColor()
      collectionView.pagingEnabled = false
      collectionView.scrollEnabled = true
      collectionView.showsVerticalScrollIndicator = true
      collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(collectionView)
      
      let viewsDict = ["collectionView":collectionView, "navBar":navBar]
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[navBar]-0-[collectionView]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      loadPostsFromAPI()
      collectionView.reloadData()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
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
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return posts.count
   }
   
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MyPostsCollectionViewCell
      let myPost = posts[indexPath.indexAtPosition(0)]
      
      cell.locationLabel.text = "\(myPost.startingLoc) \u{2192} \(myPost.endingLoc)"
      cell.dateTimeLabel.text = "\(myPost.date), \(myPost.time)"
      
      return cell
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "presentNav" {
         let toViewController = segue.destinationViewController as NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return UIStatusBarStyle.LightContent
   }
}
