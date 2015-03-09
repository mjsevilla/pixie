//
//  Review.swift
//  Matches
//
//  Created by Nicole on 2/22/15.
//  Copyright (c) 2015 Pixie. All rights reserved.
//

import Foundation

class Review {
   
   enum reviewColor {
      case green, yellow, red
   }
   
   let comment: String
   let color: reviewColor
   
   init(comment: String, color: reviewColor) {
      self.comment = comment
      self.color = color
   }
}