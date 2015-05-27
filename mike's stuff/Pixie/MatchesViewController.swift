//
//  MatchesViewController
//  Matches
//
//  Created by Nicole on 2/16/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
var viewSize = CGSizeMake(0, 0)
var scrollOffset = CGPointMake(0, 0)
var startPoint = CGPointMake(0, 0)
var movedPoint = CGPointMake(0, 0)
var endPoint = CGPointMake(0, 0)

class MatchesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {
   
   var collectionView: UICollectionView!
   var currentCell: MatchCollectionViewCell?
   var currentMatch: Match!
   var transitionManager = MatchesToBioTransitionOperator()
   var navTransitionOperator = NavigationTransitionOperator()
   var viewInsets: UIEdgeInsets!
   var itemSize: CGSize!
   var topMargin: CGFloat!
   var userId: Int! = -1
   var fullName: String = "Error"
   var latitude: Double!
   var longitude: Double!
   var searchDate: String!
   var searchTime: String!
   
   private var matches = [Match]()
   private var posts = [Post]()
   
   override func loadView() {
      super.loadView()
      view.backgroundColor = UIColor.whiteColor()
      
      // Do any additional setup after loading the view, typically from a nib.
      var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      // view.frame.width/7.0*6.0 = width & height of picture
      // 114 = height of text area below picture
      itemSize = CGSize(width: view.frame.width/7.0*6.0, height: view.frame.width/7.0*6.0+114.0)
      layout.itemSize = itemSize
      layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
      viewInsets = UIEdgeInsets(top: 0, left: view.frame.width/14.0, bottom: 0, right: view.frame.width/14.0 )
      layout.headerReferenceSize = CGSizeZero
      layout.footerReferenceSize = CGSizeZero
      layout.sectionInset = viewInsets
      
      topMargin = (view.frame.height - itemSize.height - 64.0)/2.0
      //      println("topMargin: \(topMargin)")
      
      collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.registerClass(MatchCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
      collectionView.backgroundColor = UIColor.clearColor()
      collectionView.pagingEnabled = true
      collectionView.scrollEnabled = true
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
      self.view.addSubview(collectionView)
      
      let viewsDict = ["collectionView":collectionView]
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      loadPostsFromAPI()
      loadUsersFromAPI()
      collectionView.reloadData()
      
//      println("lat: \(latitude), long: \(longitude)")
//      println("search date: \(searchDate)")
//      println("search time: \(searchTime)")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      var swipeToSearchView = UISwipeGestureRecognizer(target: self, action: "handleSwipes:")
      swipeToSearchView.direction = .Down
      self.view.addGestureRecognizer(swipeToSearchView)
      
      var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
      rightSwipe.direction = .Right
      view.addGestureRecognizer(rightSwipe)
      
      /* Where "userId" is set */
      let defaults = NSUserDefaults.standardUserDefaults()
      if let savedId = defaults.stringForKey("PixieUserId") {
         userId = savedId.toInt()
      }
      if let savedFirstName = defaults.stringForKey("PixieUserFirstName") {
         fullName = savedFirstName
         if let savedLastName = defaults.stringForKey("PixieUserLastName") {
            fullName += " \(savedLastName)"
         }
      }
      
      println("MatchesViewController found userId: \(userId), name: \(fullName)")
   }
   
   func loadPostsFromAPI() {
      var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/posts?lat=\(latitude)&lon=\(longitude)&day=\(searchDate)&time=\(searchTime)"
      println("urlString: \(urlString)")
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//         println("loadPostsFromAPI json...\n\(json)")
         if let items = json["posts"] as? NSArray {
            for item in items {
               if let start_name = item["start_name"] as? String {
                  if let start_latStr = item["start_lat"] as? String {
                     let start_lat = (start_latStr as NSString).doubleValue
                     if let start_lonStr = item["start_lon"] as? String {
                        let start_lon = (start_lonStr as NSString).doubleValue
                        if let end_name = item["end_name"] as? String {
                           if let end_latStr = item["end_lat"] as? String {
                              let end_lat = (end_latStr as NSString).doubleValue
                              if let end_lonStr = item["end_lon"] as? String {
                                 let end_lon = (end_lonStr as NSString).doubleValue
                                 if let day = item["day"] as? String {
                                    if let time = item["time"] as? String {
                                       if let id = item["id"] as? Int {
                                          if let userIdStr = item["userId"] as? String {
                                             let userId = userIdStr.toInt()!
                                             if let driverEnum = item["driver_enum"] as? String {
                                                let isDriver = driverEnum == "DRIVER" ? true : false
                                                let start = Location(name: start_name, lat: start_lat, long: start_lon)
                                                let end = Location(name: end_name, lat: end_lat, long: end_lon)
                                                self.posts.append(Post(isDriver: isDriver, start: start, end: end, day: day, time: time, id: id, userId: userId))
//                                                posts[posts.count-1].toString()
                                             } else {
                                                println("error: driver_enum")
                                             }
                                          } else {
                                             println("error: userId")
                                          }
                                       } else {
                                          println("error: id")
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
         println("error json: \(error)") // print the error!
      }
   }
   
   func loadUsersFromAPI() {
      for p in posts {
         var user = User()
         var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/users/\(p.userId)"
         let url = NSURL(string: urlString)
         var request = NSURLRequest(URL: url!)
         var response: NSURLResponse?
         var error: NSErrorPointer = nil
         var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
         
         if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
//            println("json...\n\(json)\n")
            if let userIdStr = json["userId"] as? String {
               let userId = userIdStr.toInt()!
               if userId == p.userId {
                  user.userId = userId
                  if let first_name = json["first_name"] as? String {
                     if let last_name = json["last_name"] as? String {
                        user.setName(first_name, lastName: last_name)
                        if let ageStr = json["age"] as? String {
                           let age = ageStr.toInt()!
                           user.age = age
                        }
                        if let bio = json["bio"] as? String {
                           if count(bio) > 0 {
                              user.bio = bio
                           }
                        }
                        if let photoURL = json["photoURL"] as? String {
                           if count(photoURL) > 0 {
                              user.profilePic = photoURL
                           }
                        }
                        self.matches.append(Match(author: user, post: p))
//                        user.toString()
                     } else {
                        println("error: last_name")
                     }
                  } else {
                     println("error: first_name")
                  }
               } else {
                  println("error: post.userId != user.userId")
               }
            } else {
               println("error: userId")
            }
         } else {
            println("error: json object with userId: \(p.userId)")
         }
      }
   }
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return matches.count
   }
   
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MatchCollectionViewCell
      currentMatch = matches[indexPath.indexAtPosition(0)]
      
      var tap = UITapGestureRecognizer(target: self, action: "tappedImage:")
      tap.numberOfTapsRequired = 1;
      tap.numberOfTouchesRequired = 1;
      tap.delegate = self
      
      cell.messageIcon.addTarget(self, action: "sendMessage:", forControlEvents: UIControlEvents.TouchUpInside)
      
      cell.profilePic.addGestureRecognizer(tap)
      cell.profilePic.image = UIImage(data: currentMatch.author.profilePicData)
      if currentMatch.author.age > 0 {
         cell.userNameLabel.attributedText = createAttributedNameString(currentMatch.author.fullName, age: currentMatch.author.age)
      } else {
         cell.userNameLabel.attributedText = createAttributedNameStringNoAge(currentMatch.author.fullName)
      }
      cell.seekOfferLabel.text = currentMatch.post.isDriver ? "😎 Offering" : "😊 Seeking"
      cell.locationLabel.text = "\(currentMatch.post.start.name) \u{2192} \(currentMatch.post.end.name)"
      cell.dateTimeLabel.text = "\(currentMatch.post.day), \(currentMatch.post.time)"
      
      currentCell = cell
      return cell
   }
   
   func createAttributedNameString(name: String, age: Int) -> NSMutableAttributedString {
      var nameString = NSMutableAttributedString(string: name + ", \(age)")
      nameString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 20)!, range: NSMakeRange(0, count(name)+1))
      nameString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size: 20)!, range: NSMakeRange(count(name)+2, count("\(age)")))
      return nameString
      
   }
   
   func createAttributedNameStringNoAge(name: String) -> NSMutableAttributedString {
      var nameString = NSMutableAttributedString(string: name)
      nameString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Thin", size: 20)!, range: NSMakeRange(0, count(name)))
      return nameString
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func tappedImage(recognizer: UITapGestureRecognizer) {
      self.performSegueWithIdentifier("showUserBio", sender: self)
   }
   
   func handleSwipes(sender: UISwipeGestureRecognizer) {
      if sender.direction == .Down {
         self.performSegueWithIdentifier("unwindToSearchView", sender: self)
      }
   }
   
   /*
   *
   * <---------------------------------------------------------------- MIKE THIS IS FO U FO MESSAGING !!!!!!!!!!
   *
   * You might be wondering....
   *
   * Q; "Where da fuq is ma current user id and name stored at????"
   * A: - in "userId"-> a global variable; initialized in viewDidLoad() starting at line 102
   *    - in "fullName" -> a global variable; initialized in viewDidLoad() starting at line 98/100
   *
   * Q: "Where da fuq is ma user name and id for da user I vant to message????"
   * A: - in "currentMatch.author.name" and "currentMatch.author.userId"-> also a global variable;
   *      initialized at line 218 which loads the view for the current cell in view
   *
   */
   func sendMessage(sender: UIButton!) {
      var senderBtn = sender as! SenderButton
      var newConvo = PFObject(className: "Conversation")
      newConvo["user1Id"] = String(userId)
      newConvo["user1Name"] = "\(fullName)"
      newConvo["user2Id"] = String(currentMatch.author.userId)
      newConvo["user2Name"] = currentMatch.author.fullName
      newConvo["lastMessage"] = nil // <------------------- Mike for some reason this line throws an exception
      senderBtn.parseConvo = newConvo
      
      performSegueWithIdentifier("presentConvo", sender: senderBtn)
      println("Send message from \(fullName) with id \(userId) to \(currentMatch.author.fullName) with id \(currentMatch.author.userId)")
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "showUserBio" {
         if let destinationVC = segue.destinationViewController as? BioViewController {
            destinationVC.transitioningDelegate = self.transitionManager
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            var idxPath = self.collectionView.indexPathsForVisibleItems().first as! NSIndexPath
            var current = matches[idxPath.indexAtPosition(0)].author
            
            if current.age > 0 {
               destinationVC.userNameLabel.attributedText = createAttributedNameString(current.fullName, age: current.age)
            } else {
               destinationVC.userNameLabel.attributedText = createAttributedNameStringNoAge(current.fullName)
            }
            destinationVC.userBio.text = "This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio. This is my bio."
            destinationVC.profilePic.image = currentCell?.profilePic.image
         }
      }
      else if segue.identifier == "presentNav" {
         let toViewController = segue.destinationViewController as! NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
      else if segue.identifier == "presentConvo" {
         if let destVC = segue.destinationViewController as? ConversationViewController {
            let btn = sender as! SenderButton
            
            destVC.userName = btn.parseConvo!["user1Name"]!.stringValue
            destVC.userId = btn.parseConvo!["user1Id"]!.stringValue
            destVC.recipientName = btn.parseConvo!["user2Name"]!.stringValue
            destVC.convoId = btn.parseConvo!.objectId
            destVC.convo = btn.parseConvo!
         }
      }
   }
   
   @IBAction func unwindToMatches(segue:UIStoryboardSegue) {}
}

// wrapper class to send parse conversation via segue
class SenderButton: UIButton {
   var parseConvo: PFObject?
}