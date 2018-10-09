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

class FollowingsCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var following: Followings! {
        didSet {
            self.updateUI()
        }
    }
    
    
    
    func updateUI() {
        self.Label.text = following.userName
        let img = following.downloadURL
        let url = URL(string:img!)
        if let data = try? Data(contentsOf: url!)
        {
          let im: UIImage = UIImage(data: data)!
          self.imgView?.image = im
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

