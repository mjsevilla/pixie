//
//  Post.swift
//  PixieMatches
//
//  Created by Nicole on 2/15/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class Post {
   let startingLoc: String
   let endingLoc: String
   let date: String
   let time: String
   
   init(start: String, end: String, date: String, time: String) {
      startingLoc = start
      endingLoc = end
      self.date = date
      self.time = time
   }
}