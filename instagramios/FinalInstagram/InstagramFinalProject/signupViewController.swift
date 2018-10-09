//
//  signupViewController.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-23.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

class signupViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descrip: UITextField!
    
    @IBOutlet weak var signUp: UIButton!
    // outlet for name field
    @IBOutlet weak var userName: UITextField!
      // outlet for email field
    @IBOutlet weak var userEmail: UITextField!
      // outlet for password field
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userLocation: UITextField!
    
    var location:String!
    var latitude: String!
    var longitude:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        signUp.isEnabled = false
        signUp.layer.cornerRadius = 5
        userName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        userEmail.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        userPassword.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        userLocation.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        descrip.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard let habit = userName.text, !habit.isEmpty
            else {
                self.signUp.isEnabled = false
                return
        }
           guard let goal = userEmail.text, !goal.isEmpty
            else {
                self.signUp.isEnabled = false
                return
        }
        guard let pass = userPassword.text, !pass.isEmpty
            else {
                self.signUp.isEnabled = false
                return
        }
        guard let loc = userLocation.text, !loc.isEmpty
            else {
                self.signUp.isEnabled = false
                return
        }
        guard let des = descrip.text, !des.isEmpty
            else {
                self.signUp.isEnabled = false
                return
        }
          
        
        signUp.isEnabled = true
        signUp.backgroundColor = UIColor.blue
    }
    
    
    @IBAction func imagepicker(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
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
      imageView.image = image
        selectedImage = image
    
        // print(items.description)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // this method is invoked when signup button is tapped
    @IBAction func signupbuttontapped(_ sender: Any) {
        // get name, email & password from textfield boxes
        let name = userName.text!
        let email = userEmail.text!
        let password = userPassword.text!
        let description = descrip.text!
         location = userLocation.text!
        
        
        // check if fields are not empty then create a new user
        if( name != "" && password != "" && email != "" && location != ""  && imageView.image != nil){
            // this method will create a new user
            
            Auth.auth().createUser(withEmail: email, password:password, completion: { (user: User?, error: Error?) in
                if (error != nil)
                {
                    
                    print(error?.localizedDescription)
                    // if error occur in creating the user show an alert box to user telling about the error that occured
                    let alertbox = UIAlertController(title: "SIGNUP FAILED!", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title:" OK", style: .cancel, handler: nil)
                    alertbox.addAction(action)
                    self.present(alertbox, animated: true, completion: nil)
                }
                else {
                    self.getCoordinate()
                    print(user)
                    // reference variable to the database
                    let ref = Database.database().reference()
                    
                    print(ref.description())
                    // reference variable to the users node
                    let userReference = ref.child("users")
                    print(userReference.description())
                    // uid is the unique id of every user 
                    let uid = user?.uid
                    let newUserReference = userReference.child(uid!)
                    print(newUserReference.description())
                    // creating reference to storage
                    let storageref = Storage.storage().reference().child("profile_photos").child(uid!)
                    if let profileImage = self.selectedImage , let imagedata = UIImageJPEGRepresentation(profileImage, 0.1){
                        
                        storageref.putData(imagedata, metadata: nil, completion: { (metadata, Error) in
                            if (error != nil){
                                return
                            }
                            let profileImageURL = metadata?.downloadURL()?.absoluteString
                            // saving new user to the database
                            newUserReference.setValue(["name":name ,"email":email,"profileImage":profileImageURL,"id": uid,"bio":description,"latitude":self.latitude,"longitude":self.longitude])
                            print("description of new user: \(newUserReference.description())")
                            self.performSegue(withIdentifier: "signUp", sender: nil)
                        })
                    }
                    
                    
                 
                    
                }
                // ...
                
            })
            
           
        }
        else{
            print("error creating user")
            let alertbox = UIAlertController(title: "SIGNUP FAILED!", message: "All fields are mandatory ", preferredStyle: .alert)
            let action = UIAlertAction(title:" OK", style: .cancel, handler: nil)
            alertbox.addAction(action)
           self.present(alertbox, animated: true, completion: nil)
        }
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp" {
            let vc = segue.destination as! tabbarViewController
            
            
            
            print("button pressed")
        }
    }
    func getCoordinate(){
        
    
        let geocoder = CLGeocoder()
     
        geocoder.geocodeAddressString(location) { (placemarks, error)  in
            
            
            if let e = error {
                print("got an error while geocoding")
                return
            }
            
            if placemarks!.count > 0 {
                let coord = placemarks![0].location
                print(coord!.coordinate.latitude)
                print(coord!.coordinate.longitude)
                
                self.latitude = String(coord!.coordinate.latitude)
                self.longitude = String(coord!.coordinate.longitude)
                
                
                
            }
        }
        geocoder.geocodeAddressString(location) { (placemarks, error)  in
            
            
            if let e = error {
                print("got an error while geocoding")
                return
            }
            
            if placemarks!.count > 0 {
                let coord = placemarks![0].location
                print(coord!.coordinate.latitude)
                print(coord!.coordinate.longitude)
                
                self.latitude = String(coord!.coordinate.latitude)
                self.longitude = String(coord!.coordinate.longitude)
                
                
                
            }
        }
        
    }
 
}
