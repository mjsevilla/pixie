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
   let profilePicData: NSData!
   let userId: Int
   
   init(name: String, age: Int, bio: String, profilePic: String, userId: Int) {
      self.name = name
      self.age = age
      self.bio = bio
      self.profilePic = profilePic
      let url = NSURL(string: profilePic)
      self.profilePicData = NSData(contentsOfURL: url!)
      self.userId = userId
   }
   
   func toString() {
      println("name: \(name)")
      println("age: \(age)")
      println("bio: \(bio)")
      //println("profilePic: \(profilePic)")
      println("userId: \(userId)")
   }
}