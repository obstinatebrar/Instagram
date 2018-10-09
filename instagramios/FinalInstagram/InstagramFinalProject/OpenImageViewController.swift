//
//  OpenImageViewController.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-23.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase

class OpenImageViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var comments = [Comment]()
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    var captionText = String()
    var imageDownloadoadingURL = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        print("afafaffafa")
        print(imageDownloadoadingURL)
        let url = URL(string:imageDownloadoadingURL)
        if let data = try? Data(contentsOf: url!)
        {
            let im: UIImage = UIImage(data: data)!
            self.imageView.image = im
        }
        self.captionLabel.text = self.captionText
       /* if let imageDownloadURL = imageDownloadoadingURL {
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
        }*/
        
        Database.database().reference().child("comments").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            let newPost = Comment(snapshot: snapshot)
        
            DispatchQueue.main.async {
                self.comments.append(newPost)
                self.tableView.reloadData()
               
                
            }
            Database.database().reference().child("comments").observeSingleEvent(of: .value, with: {
                (snapshot) in
                //  print(snapshot)
                //   print(snapshot.childrenCount)
                
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    print(dictionary["date"] as? String)
                    
                    
               
                    //self.profileImageView.image = im
                }
                
                
            }, withCancel: nil)
    }
    tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //  return 10
      return comments.count
    }
    
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mynewCell", for: indexPath)
            as! commentTableViewCell
       
       let comment = self.comments[indexPath.row]
        
        cell.comment = comment
      
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    @IBAction func backButton(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }
    
}
