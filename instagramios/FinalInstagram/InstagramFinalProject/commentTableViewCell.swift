//
//  commentTableViewCell.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import FirebaseStorage
class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userComment: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var comment: Comment! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        
        date.text = comment.date
        userName.text = comment.userName
        userComment.text = comment.userComment
        
        if let imageDownloadURL = comment.downloadURL {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("******** \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.userImage.image = image
                        }
                    }
                }
                
            }
        }
    }


}
