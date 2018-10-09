//
//  UpdateProfileViewController.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-25.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase
class UpdateProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func UpdateProfile(_ sender: Any) {
       let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().child("users").child(uid!)
        /*ref.setValue(["email": email.text!,
            "name": name.text! ,"profileImage": profileImage.image!
        ])*/
        let storageref = Storage.storage().reference().child("profile_photos").child(uid!)
        if let profileImage = profileImage.image , let imagedata = UIImageJPEGRepresentation(profileImage, 0.1){
            
            storageref.putData(imagedata, metadata: nil, completion: { (metadata, Error) in
               
            
                let profileImageURL = metadata?.downloadURL()?.absoluteString
                // saving new user to the database
                ref.setValue(["name":self.name.text ,"email":self.email.text,"profileImage":profileImageURL])
                print("description of new user: \(ref.description())")
                self.performSegue(withIdentifier: "signUp", sender: nil)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ImagePickerPressed(_ sender: Any) {
        let libPhoto = UIImagePickerController()
        libPhoto.delegate = self
        libPhoto.sourceType = UIImagePickerControllerSourceType.photoLibrary//setting source for image
        self.present(libPhoto, animated: true)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let gotImgfrmLib = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = gotImgfrmLib
        }
        else {
            print("Error picking an image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
