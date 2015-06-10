//
//  MyProfileViewController.swift
//  Pixie
//
//  Created by Nicole on 4/27/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    var blurView: UIVisualEffectView!
    var profilePicBlurred: UIImageView!
    var profilePic: UIImageView!
    var nameLabel: UILabel!
    var bioLabel: UILabel!
    var profPic: UIImage!
    var userId: Int! = -1
    let defaults = NSUserDefaults.standardUserDefaults()
    var navTransitionOperator = NavigationTransitionOperator()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if (defaults.dataForKey("PixieUserProfPic") == nil) {
			println("viewdidload load")

			loadUserPicFromAPI()
			var gaussianFilter = GPUImageGaussianBlurFilter()
			gaussianFilter.blurRadiusInPixels = 9
			gaussianFilter.blurPasses = 2
			self.profPic = self.cropToSquare(image: profPic)
			self.defaults.setObject(UIImagePNGRepresentation(self.profPic), forKey: "PixieUserProfPic")
			let blurredImage = gaussianFilter.imageByFilteringImage(profPic)
			self.defaults.setObject(UIImagePNGRepresentation(blurredImage), forKey: "PixieUserBlurredProfPic")
			self.defaults.setObject(0, forKey: "PicChange")
		}
		
		var imageData = defaults.dataForKey("PixieUserBlurredProfPic")
        var blurredImage = UIImage(data: imageData!)
        
        profilePicBlurred = UIImageView(image: blurredImage)
        profilePicBlurred.setTranslatesAutoresizingMaskIntoConstraints(false)
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(profilePicBlurred)
        
        profilePic = UIImageView(image: UIImage(data: defaults.dataForKey("PixieUserProfPic")!))
        profilePic.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(profilePic)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 24)!
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.lineBreakMode = .ByClipping
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(nameLabel)
        
        bioLabel = UILabel()
        bioLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 16)!
        bioLabel.textAlignment = .Left
        bioLabel.numberOfLines = 0
        bioLabel.lineBreakMode = .ByWordWrapping
        bioLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(bioLabel)
        
        setConstraints()
        
        self.editBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 18)!], forState: UIControlState.Normal)
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)
		
		var didChange = defaults.integerForKey("PicChange")
		
		if (didChange == 1) {
			var tempData = self.defaults.dataForKey("PixieUserProfPic")
			var gaussianFilter = GPUImageGaussianBlurFilter()
			gaussianFilter.blurRadiusInPixels = 9
			gaussianFilter.blurPasses = 2
			self.profPic = self.cropToSquare(image: UIImage(data: tempData!)!)
			self.defaults.setObject(UIImagePNGRepresentation(self.profPic), forKey: "PixieUserProfPic")
			let blurredImage = gaussianFilter.imageByFilteringImage(UIImage(data: tempData!))
			self.defaults.setObject(UIImagePNGRepresentation(blurredImage), forKey: "PixieUserBlurredProfPic")
			self.defaults.setObject(0, forKey: "PicChange")
		}
			
		var imageData = self.defaults.dataForKey("PixieUserBlurredProfPic")
		var blurredImage = UIImage(data: imageData!)
			
		self.profilePicBlurred.image = blurredImage
		self.profilePicBlurred.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
		self.blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
			
		self.profilePic.image = UIImage(data: self.defaults.dataForKey("PixieUserProfPic")!)
		self.profilePic.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		let first = defaults.stringForKey("PixieUserFirstName")!
		let last = defaults.stringForKey("PixieUserLastName")!
		let age = defaults.integerForKey("PixieUserAge")
		
		if age != 0 {
			nameLabel.text = "\(first) \(last), \(age)"
		} else {
			nameLabel.text = "\(first) \(last)"
		}
		bioLabel.text = defaults.stringForKey("PixieUserBio")
		if (bioLabel.text!.isEmpty || bioLabel.text == "NULL" || bioLabel.text == "Tell us about yourself!") {
			bioLabel.text = "No bio :("
		}
	}
    
    func setConstraints() {
        let viewsDict = ["profilePic":profilePic, "profilePicBlurred":profilePicBlurred, "nameLabel":nameLabel, "bioLabel":bioLabel]
        let metrics = ["blurHeight":self.view.frame.width, "profPicSize":self.view.frame.width*(3.0/5.0)]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[profilePicBlurred(blurHeight)]-10-[bioLabel]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[profilePic(profPicSize)]-5-[nameLabel]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[profilePicBlurred]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[profilePic(profPicSize)]", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[bioLabel]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
        
        self.view.addConstraint(NSLayoutConstraint(item: profilePic, attribute: .CenterX, relatedBy: .Equal, toItem: profilePicBlurred, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: profilePic, attribute: .CenterY, relatedBy: .Equal, toItem: profilePicBlurred, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: profilePic, attribute: .CenterX, multiplier: 1, constant: 0))
        
        self.view.layoutIfNeeded()
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.performSegueWithIdentifier("presentNav", sender: self)
        }
    }
    
    @IBAction func unwindToMyProf(sender: UIStoryboardSegue) {}
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as! NavigationViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.navTransitionOperator
            toViewController.presentingView = self
        }
        if segue.identifier == "presentEditProf" {
            if let editVC = segue.destinationViewController as? EditProfileViewController {
                self.modalPresentationStyle = UIModalPresentationStyle.Custom
            }
        }
    }
    
    func loadUserPicFromAPI() {
        if let savedId = defaults.stringForKey("PixieUserId") {
            userId = savedId.toInt()
        }
        
        var urlString = "http://ec2-54-69-253-12.us-west-2.compute.amazonaws.com/pixie/userPic/\(userId)"
        let url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data =  NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error:nil)! as NSData
        
        profPic = UIImage(data: data)
    }
}
