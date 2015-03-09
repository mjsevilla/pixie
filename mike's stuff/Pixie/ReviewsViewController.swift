//
//  ReviewsViewController.swift
//  Matches
//
//  Created by Nicole on 2/22/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
   
   var tableView: UITableView!
   let reviews: [Review] = [Review(comment: "Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1", color: Review.reviewColor.green), Review(comment: "Comment 2, Comment 2, Comment 2, Comment 2, Comment 2", color: Review.reviewColor.yellow), Review(comment: "Comment 3", color: Review.reviewColor.red), Review(comment: "C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4", color: Review.reviewColor.red), Review(comment: "Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1", color: Review.reviewColor.green), Review(comment: "Comment 2, Comment 2, Comment 2, Comment 2, Comment 2", color: Review.reviewColor.yellow), Review(comment: "Comment 3", color: Review.reviewColor.red), Review(comment: "C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4", color: Review.reviewColor.red), Review(comment: "Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1", color: Review.reviewColor.green), Review(comment: "Comment 2, Comment 2, Comment 2, Comment 2, Comment 2", color: Review.reviewColor.yellow), Review(comment: "Comment 3", color: Review.reviewColor.red), Review(comment: "C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4", color: Review.reviewColor.red), Review(comment: "Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1 Comment 1", color: Review.reviewColor.green), Review(comment: "Comment 2", color: Review.reviewColor.yellow), Review(comment: "Comment 3", color: Review.reviewColor.red), Review(comment: "C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4 C o m m e n t 4", color: Review.reviewColor.red)]
   
   override func loadView() {
      view = UIView(frame: UIScreen.mainScreen().bounds)
      
      var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
      blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(blurEffectView)
      
      var reviewTitle = UILabel()
      reviewTitle.textAlignment = .Center
      reviewTitle.text = "\u{2500}\u{2500} Reviews \u{2500}\u{2500}"
      reviewTitle.font = UIFont(name: "Syncopate-Regular", size: 24)
      reviewTitle.textColor = UIColor(red: 0x00, green: 0xBC, blue: 0xD4, alpha: 1.0)
      reviewTitle.userInteractionEnabled = true
      reviewTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
      view.addSubview(reviewTitle)
      
      tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
      tableView.delegate = self
      tableView.dataSource = self
      tableView.backgroundColor = UIColor.clearColor()
      tableView.layoutMargins = UIEdgeInsetsZero
      tableView.registerClass(ReviewTableViewCell.self, forCellReuseIdentifier: "cell")
      tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 100.0
      tableView.tableFooterView = UIView(frame: CGRectZero)
      view.addSubview(tableView)
      
      let viewsDict = ["tableView":tableView, "reviewTitle":reviewTitle, "blurEffectView":blurEffectView]
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[reviewTitle]-0-[tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[reviewTitle]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurEffectView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      view.layoutIfNeeded()
      
      
      var tapDown = UITapGestureRecognizer(target: self, action: "tapDown:")
      tapDown.numberOfTapsRequired = 1
      tapDown.delegate = self
      reviewTitle.addGestureRecognizer(tapDown)
      
      var doubleTapDown = UITapGestureRecognizer(target: self, action: "tapDown:")
      doubleTapDown.numberOfTapsRequired = 2
      doubleTapDown.delegate = self
      view.addGestureRecognizer(doubleTapDown)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   /*
   * UITableViewDataSource protocol methods
   */
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //if let r = reviews {
      return reviews.count
      //} else {
      // println("ReviewsViewController.swift: Ruh roah, reviews.count was 0")
      // return 0
      //}
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as ReviewTableViewCell
      cell.commentLabel.text = self.reviews[indexPath.row].comment
      switch(self.reviews[indexPath.row].color) {
      case Review.reviewColor.green:
         cell.colorImage.image = UIImage(named: "green-car.png")
      case Review.reviewColor.yellow:
         cell.colorImage.image = UIImage(named: "yellow-car.png")
      case Review.reviewColor.red:
         cell.colorImage.image = UIImage(named: "red-car.png")
      default:
         println("No color found for review.")
      }
      cell.separatorInset = indexPath.row == reviews.count-1 ? UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0) : UIEdgeInsetsZero
      cell.layoutMargins = UIEdgeInsetsZero
      
      return cell
   }
   
   func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      return false
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   
   /*
   *
   */
   
   func tapDown(recognizer: UITapGestureRecognizer) {
      self.performSegueWithIdentifier("unwindToBio", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
   
}
