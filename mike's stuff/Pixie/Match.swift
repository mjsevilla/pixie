//
//  Match.swift
//  PixieMatches
//
//  Created by Nicole on 1/26/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class Match {
   let author: User
   let post: Post
   
   init(author: User, post: Post) {
      self.author = author
      self.post = post
   }
}