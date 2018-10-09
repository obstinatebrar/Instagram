//
//  FollowingsCell.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

//
//  UserCELL.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var FollowersLabel: UILabel!
    // @IBOutlet weak var Label: UILabel!
  //  @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var FollowersImageView: UIImageView!
    
    var follower: Followers! {
        didSet {
            self.updateUI()
        }
    }
    
    
    
    func updateUI() {
        self.FollowersLabel.text = follower.userName
        let img = follower.downloadURL
        let url = URL(string:img!)
        if let data = try? Data(contentsOf: url!)
        {
            let im: UIImage = UIImage(data: data)!
            self.FollowersImageView?.image = im
        }
        
        
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}


