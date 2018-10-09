







//
//  User.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-03-31.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//



import UIKit
import Firebase
import SwiftyJSON

class Users {
    var name: String!
    var email: String!
    var profileImage: String?
    var id: String?
    
    init(name: String, email: String,profileImage: String,id:String) {
        self.name = name
        self.email = email
        self.profileImage = profileImage
        self.id = id
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.name = json["name"].stringValue
        self.email = json["email"].string
        self.profileImage = json["profileImage"].string
        self.id = json["id"].string
    }
    
}




