//
//  ViewController.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-22.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//
import Firebase
import UIKit
import SwiftyJSON
class ViewController: UIViewController,UICollectionViewDataSource ,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imageUrl = ""
    @IBOutlet weak var collectionView: UICollectionView!
  
    @IBOutlet weak var numOfFollowing: UILabel!
    @IBOutlet weak var numOfFollowers: UILabel!
    
    
    @IBOutlet weak var desciptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
 
    @IBOutlet weak var numOfPosts: UILabel!
 
    
   // @IBOutlet weak var collectionView: UICollectionView!
    var imgArray = [UIImage]()
    var img = UIImage()
    var st = String()
    var posts = [Post]()
    var imageToPassToNextViewController = UIImage()
   // var imgArray: [UIImage] = []
    //var images = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        
        
        
        
        checkIfUserLoggedIn()
        followersCount()
        followingCount()
       // postsCount()
        getData()
        
          let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("posts").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            let newPost = Post(snapshot: snapshot)
            DispatchQueue.main.async {
                self.posts.append(newPost)
                self.collectionView.reloadData()
                
            }
        }
        
        
        numOfPosts.text = "\(posts.count)"
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    func followersCount(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("follower").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            var count = snapshot.childrenCount-1
    
            DispatchQueue.main.async {
               self.numOfFollowers.text = "\(count)"
                
            }
        }
        
    }
    func followingCount() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("following").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            print(snapshot)
            let count = snapshot.childrenCount+3
            print(count)
            DispatchQueue.main.async {
                self.numOfFollowing.text = "\(count)"
    
                
            }
        }
    }
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("not loggged in")
        }
        else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {
                (snapshot) in
              //  print(snapshot)
             //   print(snapshot.childrenCount)
                
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.profileNameLabel.text = dictionary["name"] as? String
                    self.desciptionLabel.text = dictionary["bio"] as? String
                    
                    let image = dictionary["profileImage"] as! String
                    let url = URL(string:image)
                    if let data = try? Data(contentsOf: url!)
                    {
                        let im: UIImage = UIImage(data: data)!
                         self.profileImageView.image = im
                    }
                    //self.profileImageView.image = im
            }
                
                
            }, withCancel: nil)
  
         }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionsheet = UIAlertController(title: "Photo Source", message: "Pick a Source", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction )in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action: UIAlertAction )in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true,completion: nil)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionsheet,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgArray.append(image)
        collectionView.reloadData()
        
        
        
       // print(items.description)
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return images.count
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell",
                                                      for: indexPath) as! CollectionViewCell
        
        let post = self.posts[indexPath.row]
        
        cell.post = post
        self.numOfPosts.text = "\(self.posts.count)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width =  collectionView.frame.width / 3 - 1
        return CGSize(width:width,height:width)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "OpenImageViewController") as! OpenImageViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let item =  self.posts[indexPath.row]
        vc.imageDownloadoadingURL = item.downloadURL!
        vc.captionText = item.caption!
        self.navigationController?.pushViewController(vc, animated: true)
        appDelegate.window?.rootViewController = vc
        
       
    }

    func getData(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
               print( dictionary["0"] as? String)
                
                
                let image = dictionary["profileImage"] as! String
                let url = URL(string:image)
                if let data = try? Data(contentsOf: url!)
                {
                    let im: UIImage = UIImage(data: data)!
                    self.profileImageView.image = im
                }
                //self.profileImageView.image = im
            }
            
            
        }, withCancel: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
            let vc:OpenImageViewController = segue.destination as! OpenImageViewController
            let indexPath = self.st
            print(st)
            vc.imageDownloadoadingURL = indexPath
            print("buttonpressed")
        }
        if segue.identifier == "logout" {
            let vc = segue.destination as! LoginViewController
            
            
            
            print("button pressed")
        }
        
    }
    
    /*@IBAction func LogoutButtonPressed(_ sender: Any) {
        print(Auth.auth().currentUser)
        try! Auth.auth().signOut()
         print(Auth.auth().currentUser)
      self.performSegue(withIdentifier: "logout", sender: nil)
    }*/
    
    @IBAction func aa(_ sender: Any) {
        print(Auth.auth().currentUser)
        try! Auth.auth().signOut()
        print(Auth.auth().currentUser)
        self.performSegue(withIdentifier: "logout", sender: nil)
    }
    
}

