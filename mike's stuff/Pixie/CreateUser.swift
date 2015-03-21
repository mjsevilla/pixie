//
//  CreateUser.swift
//  Pixie
//
//  Created by Cameron Javier on 3/20/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

import Foundation
class CreateUser {
   func generateHttp(name:String, emailParam: String, password: String, genderParam: String, bday: String) -> Dictionary<String, String> {
      var email = emailParam;
      var gender: String;
      var age: NSInteger = -1;
      
      if(bday.utf16Count == 10) {
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
         age = Int(timeInterval)
      }
          
      
      if(genderParam == "male") {
         gender = "M";
      }
      else if (genderParam == "female"){
         gender = "F"
      }
      else {
         gender = "UNDISCLOSED"
      }
      
      //needs to be redone
      if (emailParam == "") {
         email = name;
      }
      
      if (age == -1) {
         return ["email": email, "password": password, "name": name, "gender": gender];
      }
      else {
         return ["email": email, "password": password, "name": name, "gender": gender, "age": String(age)];
      }      
   }
}
