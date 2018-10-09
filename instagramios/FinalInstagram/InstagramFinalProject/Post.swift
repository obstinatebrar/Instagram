//
//  Post.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-30.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//


//
//  Post.swift
//  FirebasePhotos
//
//  Created by Duc Tran on 10/9/17.
//  Copyright © 2017 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class Post {
     var image: UIImage!
    var caption: String!
    var downloadURL: String?
    
    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.caption = json["caption"].stringValue
        self.downloadURL = json["imageDownloadURL"].string
    }
    
    func save() {
          let uid = Auth.auth().currentUser?.uid
        let newPostRef = Database.database().reference().child("users").child(uid!).child("posts").childByAutoId()
        let newPostPublicRef = Database.database().reference().child("posts").childByAutoId()
        let newPostKey = newPostRef.key
        
        // 1. save image
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let storage = Storage.storage().reference().child("images/\(newPostKey)")
            
            storage.putData(imageData).observe(.success, handler: { (snapshot) in
                self.downloadURL = snapshot.metadata?.downloadURL()?.absoluteString
                let postDictionary = [
                    "imageDownloadURL" : self.downloadURL,
                    "caption" : self.caption,
                    "postId": newPostKey
                ]
                newPostRef.setValue(postDictionary)
                newPostPublicRef.setValue(postDictionary)
                
            })
        }
    }
}











