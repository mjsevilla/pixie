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
   var transitionManager = MatchesToBioTransitionOperator()
   var navTransitionOperator = NavigationTransitionOperator()
   var viewInsets: UIEdgeInsets!
   var itemSize: CGSize!
   
   private var matches = [Match]()
   private var posts = [Post]()
   
   
   /*
   private var matches = [
   Match(author: User(name: "Nicki Brower", age: 21, bio: "My name is Nicki, but you can call me Dre.", profilePic: "https://scontent.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/1896738_10205001610871877_5554224394457450129_n.jpg?oh=bd7620665a45b1a470646396a73b6e15&oe=5574CB74"), post: Post(start: "San Francisco, CA", end: "San Luis Obispo, CA", date: "Monday, February 23rd", time:"2:00pm")),
   Match(author: User(name: "Cameron Javier", age: 21, bio: "Oh lookey here, some bloak didn't finish his wine.", profilePic: "https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xfp1/v/t1.0-9/10711065_910657175628707_1758789905052961848_n.jpg?oh=18a99b404cd58079374b259dd37813f0&oe=557E45C0&__gda__=1438272073_8f00d14d2680b66149753ffc73323d1c"), post: Post(start: "San Luis Obispo, CA", end: "San Francisco, CA", date: "Tuesday, February 24nd", time:"4:00pm - 8:00pm")),
   Match(author: User(name: "Kaveh Karimiyanha", age: 21, bio: "Fell asleep and woke up covered in bitches.", profilePic: "https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/10460713_10152708363287852_1771250857885567270_n.jpg?oh=ca3a50ae43527203be1d50f3262df137&oe=558CE844&__gda__=1438301243_0ad8b7bd9d4b406cd07670e84f195b77"), post: Post(start: "San Luis Obispo, CA", end: "Las Vegas, NV", date: "Thursday, February 26th", time:"Anytime")),
   Match(author: User(name: "Mike Sevilla", age: 21, bio: "Damn son where'd you find this?", profilePic: "https://scontent.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/10437688_10205981335841385_938020590659785566_n.jpg?oh=e865b2ed67fa628eb93c0e0c95b2a6f9&oe=5577647C"), post: Post(start: "Santa Barbara, CA", end: "Los Angeles, CA", date: "Sunday, February 29th", time:"11:00am")),
   Match(author: User(name: "Nicki Brower", age: 21, bio: "Like, omg I love my dad so much #gogreek #fashion #drunk #lol #foodporn #waitwhat? #exactly.", profilePic: "https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/1528487_10205441832237136_8528150063642689169_n.jpg?oh=b6315e0a5340f02b7756999e7c8970c4&oe=5576EF20&__gda__=1438495257_848246030d2f93c76536eea6cffa6852"), post: Post(start: "San Francisco, CA", end: "San Luis Obispo, CA", date: "Monday, February 23rd", time:"2:00pm")),
   Match(author: User(name: "Cameron Javier", age: 21, bio: "To infinity, and beyond!", profilePic: "https://scontent.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/1391995_918189734875451_7461336485708203728_n.jpg?oh=cecc0373e43a5b28f868292a803d0999&oe=5587D3C6"), post: Post(start: "San Luis Obispo, CA", end: "San Francisco, CA", date: "Tuesday, February 24nd", time:"4:00pm - 8:00pm")),
   Match(author: User(name: "Kaveh Karimiyanha", age: 21, bio: "U rage bro?", profilePic: "https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xaf1/t31.0-8/175541_10151143613027852_1432017663_o.jpg"), post: Post(start: "San Luis Obispo, CA", end: "Las Vegas, NV", date: "Thursday, February 26th", time:"Anytime")),
   Match(author: User(name: "Mike Sevilla", age: 21, bio: "Honey! Where is my supersuit?!", profilePic: "https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xpf1/t31.0-8/1053209_10201440172995152_2135534289_o.jpg"), post: Post(start: "Santa Barbara, CA", end: "Los Angeles, CA", date: "Sunday, February 29th", time:"11:00am"))
   ]
   */
   
   override func loadView() {
      super.loadView()
      view.backgroundColor = UIColor.whiteColor()
      
      // Do any additional setup after loading the view, typically from a nib.
      var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
      itemSize = CGSize(width: view.frame.width/8.0*7.0, height: self.getHeight(view.frame.width))
      layout.itemSize = itemSize
      layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
      viewInsets = UIEdgeInsets(top: 0, left: view.frame.width/16.0, bottom: 0, right: view.frame.width/16.0 )
      layout.sectionInset = viewInsets
      
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
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
      
      loadPostsFromAPI()
      loadUsersFromAPI()
      collectionView.reloadData()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      var swipeToSearchView = UISwipeGestureRecognizer(target: self, action: "handleSwipes:")
      swipeToSearchView.direction = .Down
      self.view.addGestureRecognizer(swipeToSearchView)
      
      var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
      rightSwipe.direction = .Right
      view.addGestureRecognizer(rightSwipe)
   }
   
   func loadPostsFromAPI() {
      var urlString = "http://ec2-54-148-100-12.us-west-2.compute.amazonaws.com/pixie/posts"
      let url = NSURL(string: urlString)
      var request = NSURLRequest(URL: url!)
      var response: NSURLResponse?
      var error: NSErrorPointer = nil
      var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
      
      if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
         if let items = json["posts"] as? NSArray {
            for item in items {
               if let start = item["start"] as? String {
                  if let end = item["end"] as? String {
                     if let day = item["day"] as? String {
                        if let time = item["time"] as? String {
                           if let userId = item["userId"] as? Int {
                              if let driverEnum = item["driverEnum"] as? String {
                                 let isDriver = driverEnum == "driver" ? true : false
                                 self.posts.append(Post(isDriver: isDriver, start: start, end: end, date: day, time: time, userId: userId))
                              }
                           } else {
                              println("error: userId")
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
            println("error: posts")
         }
      } else {
         println("error \(error)") // print the error!
      }
   }
   
   func loadUsersFromAPI() {
      for p in posts {
         var urlString = "http://ec2-54-148-100-12.us-west-2.compute.amazonaws.com/pixie/users/\(p.userId)"
         let url = NSURL(string: urlString)
         var request = NSURLRequest(URL: url!)
         var response: NSURLResponse?
         var error: NSErrorPointer = nil
         var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
         
         if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let id = json["id"] as? Int {
               if id == p.userId {
                  if let name = json["name"] as? String {
                     if let age = json["age"] as? Int {
                        if let bio = json["bio"] as? String {
                           if let photoURL = json["photoURL"] as? String {
                              if(bio != "" && photoURL != "") {
                                 var currUser = User(name: name, age: age, bio: bio, profilePic: photoURL, userId: id)
                                 self.matches.append(Match(author: currUser, post: p))
                              }
                              else {
                                 var currUser = User(name: name, age: -1, bio: "No bio :(", profilePic: "http://upload.wikimedia.org/wikipedia/commons/3/31/SlothDWA.jpg", userId: id)
                                 println("yes");
                                 self.matches.append(Match(author: currUser, post: p))
                              }
                           } else {
                              println("error: photoURL")
                           }
                        } else {
                           println("error: bio")
                        }
                     } else {
                        var currUser = User(name: name, age: -1, bio: "No bio :(", profilePic: "http://upload.wikimedia.org/wikipedia/commons/3/31/SlothDWA.jpg", userId: id)
                        self.matches.append(Match(author: currUser, post: p))
                     }
                  } else {
                     println("error: name")
                  }
               } else {
                  println("error: post.userId != user.userId")
               }
            } else {
               println("error: id")
            }
         } else {
            println("error: json object")
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
      let myMatch = matches[indexPath.indexAtPosition(0)]
      
      var tap = UITapGestureRecognizer(target: self, action: "tappedImage:")
      tap.numberOfTapsRequired = 1;
      tap.numberOfTouchesRequired = 1;
      tap.delegate = self
      
      cell.profilePic.addGestureRecognizer(tap)
      cell.profilePic.image = UIImage(data: myMatch.author.profilePicData)
      if myMatch.author.age > 0 {
         cell.userNameLabel.attributedText = createAttributedNameString(myMatch.author.name, age: myMatch.author.age)
      } else {
         cell.userNameLabel.attributedText = createAttributedNameStringNoAge(myMatch.author.name)
      }
      cell.seekOfferLabel.text = myMatch.post.isDriver ? "😎 Offering" : "😊 Seeking"
      cell.locationLabel.text = "\(myMatch.post.startingLoc) \u{2192} \(myMatch.post.endingLoc)"
      cell.dateTimeLabel.text = "\(myMatch.post.date), \(myMatch.post.time)"
      
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
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      println("segue.identifier == \(segue.identifier)")
      
      if (segue.identifier == "showUserBio") {
         
         if let destinationVC = segue.destinationViewController as? BioViewController {
            
            destinationVC.transitioningDelegate = self.transitionManager
            destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            var idxPath = self.collectionView.indexPathsForVisibleItems().first as! NSIndexPath
            var current = matches[idxPath.indexAtPosition(0)].author
            
            if current.age > 0 {
               destinationVC.userNameLabel.attributedText = createAttributedNameString(current.name, age: current.age)
            } else {
               destinationVC.userNameLabel.attributedText = createAttributedNameStringNoAge(current.name)
            }
            destinationVC.userBioLabel.text = current.bio
            destinationVC.profilePic.image = currentCell?.profilePic.image
            destinationVC.widthMargin = viewInsets.left
            destinationVC.heightMargin = currentCell?.frame.origin.y
            destinationVC.itemHeight = itemSize.height
         }
      } else if segue.identifier == "presentNav" {
         println("trying to presentNav :/")
         let toViewController = segue.destinationViewController as! NavigationViewController
         self.modalPresentationStyle = UIModalPresentationStyle.Custom
         toViewController.transitioningDelegate = self.navTransitionOperator
         toViewController.presentingView = self
      }
   }
   
   @IBAction func unwindToMatches(segue:UIStoryboardSegue) {}
   
   func getHeight(width: CGFloat) -> CGFloat {
      if width == 414.0 {
         return 465.75 + 32.0
      } else if width == 375.0 {
         return 421.875 + 32.0
      } else {
         return 360.0 + 32.0
      }
   }
   
}