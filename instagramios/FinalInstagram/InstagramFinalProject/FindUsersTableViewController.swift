//
//  FindUsersTableViewController.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-03-31.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import  Firebase
class FindUsersTableViewController: UITableViewController {
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var img: UIImageView!
    
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
print("viewdidddddddd")
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            let newUser = Users(snapshot: snapshot)
            DispatchQueue.main.async {
                self.users.append(newUser)
                self.tableView.reloadData()
                
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
        return self.users.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserCELL

        let user = self.users[indexPath.row]
        cell.textLabel?.text = "Follow"
       // cell.detailTextLabel?.text = "follw"
        cell.usr = user
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
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserCELL
        let user = self.users[indexPath.row]
        
         var selectedUser =   users[indexPath.row]
         var usrname = selectedUser.name
        var usrid = selectedUser.id
        var usrImage = selectedUser.profileImage
        
        
          let uid = Auth.auth().currentUser?.uid
        let newfollowing = Database.database().reference().child("users").child(uid!).child("following").child(usrid!)
   
            
            
                let followingDictionary = [
                    "name" : usrname,
                    "profilePicture" : usrImage,
                    "id" : usrid
                ]
                newfollowing.setValue(followingDictionary)
        cell.textLabel?.text = "Following"
        
       // let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            //  print(snapshot)
            //   print(snapshot.childrenCount)
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var currentUserName = dictionary["name"] as? String
                 var currentUserImage = dictionary["profileImage"] as? String
                
                let newfollower = Database.database().reference().child("users").child(usrid!).child("follower").child(uid!)
                
                
                
                let followerDictionary = [
                    "name" : currentUserName,
                    "profilePicture" : currentUserImage,
                    "id" : uid
                ]
                newfollower.setValue(followerDictionary)
                
                 }
                //self.profileImageView.image = im
            
            
            
        }, withCancel: nil)
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        
        print(currentCell.textLabel!.text)
    currentCell.textLabel!.text = "following"
        
        
        
            }
    }



