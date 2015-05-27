//
//  User.swift
//  PixieMatches
//
//  Created by Nicole on 2/15/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class User {
   var firstName: String!
   var lastName: String!
   var fullName: String!
   var age: Int!
   var bio: String!
   var profilePic: String!
   var profilePicData: NSData!
   var userId: Int!
   
   init() {
      self.age = -1
      self.bio = "No bio :("
      setProfPic("http://upload.wikimedia.org/wikipedia/commons/3/31/SlothDWA.jpg")
   }
   
   init(firstName: String, lastName: String, age: Int, bio: String, profilePic: String, userId: Int) {
      setName(firstName, lastName: lastName)
      setProfPic(profilePic)
      self.age = age
      self.bio = bio
      self.userId = userId
   }
   
   func setName(firstName: String, lastName: String) {
      self.firstName = firstName
      self.lastName = lastName
      self.fullName = "\(firstName) \(lastName)"
   }
   
   func setProfPic(profilePic: String) {
      self.profilePic = profilePic
      let url = NSURL(string: profilePic)
      self.profilePicData = NSData(contentsOfURL: url!)
   }
   
   func toString() {
      println("name: \(fullName)")
      println("age: \(age)")
      println("bio: \(bio)")
      println("profilePic: \(profilePic)")
      println("userId: \(userId)")
   }
}