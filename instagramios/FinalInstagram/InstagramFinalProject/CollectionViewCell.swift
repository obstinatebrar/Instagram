//
//  CollectionViewCell.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-23.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
    
        
        
        if let imageDownloadURL = post.downloadURL {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("******** \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
                
            }
        }
    }
    
}
