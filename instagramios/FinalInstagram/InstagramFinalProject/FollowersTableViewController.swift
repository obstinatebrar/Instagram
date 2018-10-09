//
//  FindUsersTableViewController.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-03-31.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import  Firebase
class FollowersTableViewController: UITableViewController {
    // @IBOutlet var tableview: UITableView!
    
    @IBOutlet var FolloweTableView: UITableView!
    //  @IBOutlet var tableview: UITableView!
    // @IBOutlet var tableView: UITableView!
    // @IBOutlet weak var img: UIImageView!
    
    
    var followers = [Followers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FolloweTableView.rowHeight = 100
        print("viewdidddddddd")
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("follower").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            print(snapshot)
            let newfollower = Followers(snapshot: snapshot)
            DispatchQueue.main.async {
                self.followers.append(newfollower)
                self.FolloweTableView.reloadData()
                
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("celllsssss")
        //print(followings)
        return self.followers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell", for: indexPath) as! FollowersCell
        
        let user = self.followers[indexPath.row]
        print(user)
        //cell.textLabel?.text = "Follow"
        // cell.detailTextLabel?.text = "follw"
        cell.follower = user
        /*  // cell.user = user.name
         var image = user.profileImage
         //  cell.imageView?.image =
         //  cell.userLa = user.name!
         let url = URL(string:image!)
         if let data = try? Data(contentsOf: url!)
         {
         let im: UIImage = UIImage(data: data)!
         cell.imageView?.image = im
         }
         print(img)
         print("asssssasasas")
         
         //cell.post = post
         */
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserCELL
    //        let user = self.followings[indexPath.row]
    //
    //        var selectedUser =   followings[indexPath.row]
    //        var usrname = selectedUser.name
    //        var usrid = selectedUser.id
    //        var usrImage = selectedUser.profilePicture
    //
    //    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}





