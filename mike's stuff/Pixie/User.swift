//
//  User.swift
//  PixieMatches
//
//  Created by Nicole on 2/15/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class User {
   let name: String
   let age: Int
   let bio: String
   let profilePic: String
   let profilePicData: NSData
   
   init(name: String, age: Int, bio: String, profilePic: String) {
      self.name = name
      self.age = age
      self.bio = bio
      self.profilePic = profilePic
      self.profilePicData = NSData(contentsOfURL: NSURL(string: profilePic)!)!
   }
}