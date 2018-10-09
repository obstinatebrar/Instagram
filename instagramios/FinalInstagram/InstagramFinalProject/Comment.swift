//
//  Comment.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import Foundation


import UIKit
import Firebase
import SwiftyJSON

class Comment {
    var userImage: UIImage!
    var userComment: String!
    var date: String?
    var userName: String!
    var downloadURL:String!
    
//    init(image: UIImage, caption: String) {
//        self.image = image
//        self.caption = caption
//    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.userName = json["userName"].stringValue
        self.downloadURL = json["imageDownloadURL"].string
        self.date = json["date"].stringValue
        self.userComment = json["userComment"].string
    }
    
  
}











