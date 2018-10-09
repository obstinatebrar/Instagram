//
//  FindUsersViewController.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-04-01.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FindUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
   // @IBOutlet weak var userTableview: UITableView!
   // @IBOutlet weak var tableView: UITableView!
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidddddddd")
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            let newUser = Users(snapshot: snapshot)
            DispatchQueue.main.async {
                self.users.append(newUser)
                self.tableview.reloadData()
                
            }
        }
        
        
    }
   
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numrowssssss")
         return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)
        print("celleachhhh")
        let user = self.users[indexPath.row]
        var img = user.name
        cell.textLabel?.text = user.name
     //   cell.userLa = user.name!
        print(img)
        print("asssssasasas")
        //cell.post = post
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
}



}

