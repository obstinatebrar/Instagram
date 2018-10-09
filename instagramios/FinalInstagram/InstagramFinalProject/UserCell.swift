//
//  UserCELL.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class UserCELL: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followStatus: UILabel!
   
    var usr: Users! {
        didSet {
            self.updateUI()
        }
    }
    
    
    
    func updateUI() {
        self.userName.text = usr.name
        let img = usr.profileImage
        let url = URL(string:img!)
        if let data = try? Data(contentsOf: url!)
        {
            let im: UIImage = UIImage(data: data)!
            self.userImage?.image = im
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
