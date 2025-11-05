//
//  User.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/5/25.
//

import Foundation

struct User : Codable {
    var name : String
    var email : String
    var hashedEmail : String
    var joiningDate : Date
    var signUpMethods : String
}

