//
//  CreateUser.swift
//  Pixie
//
//  Created by Cameron Javier on 3/20/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
class CreateUser {
   func generateHttp(firstName: String, lastName: String, email: String, password: String, bday: String, bio: String, hasFB: Bool) -> Dictionary<String, String> {
      var hasFBStr = hasFB ? "1" : "0"
      var age = "NULL"
      
      if(count(bday.utf16) == 10) {
         let convertToMinutes: Double = 60
         let convertToHours: Double = 60
         let convertToDays: Double = 24
         let convertToYears: Double = 365
         let mmddccyy = NSDateFormatter();
         mmddccyy.dateFormat = "MM/dd/yyyy";
         let d: NSDate = mmddccyy.dateFromString(bday)!
         var timeInterval = d.timeIntervalSinceNow as Double
         timeInterval = -timeInterval;
         timeInterval /= convertToMinutes
         timeInterval /= convertToHours
         timeInterval /= convertToDays
         timeInterval /= convertToYears
         //This will floor the number of years the person has lived
         age = String(Int(timeInterval))
      }
      
      return ["first_name": firstName, "last_name": lastName, "email": email, "password": password, "age": age, "bio": bio, "facebook": hasFBStr];
   }
}
