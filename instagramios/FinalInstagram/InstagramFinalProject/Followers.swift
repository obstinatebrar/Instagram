


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

class Followers {
    var userName: String!
    
    var downloadURL: String?
    
    
    init(name: String,downloadURL: String) {
        self.userName = name
        self.downloadURL = downloadURL
        
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.userName = json["name"].stringValue
        self.downloadURL = json["profilePicture"].string
        
    }
    
}






