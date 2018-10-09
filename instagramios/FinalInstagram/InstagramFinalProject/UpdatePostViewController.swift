//
//  UpdatePostViewController.swift
//  InstagramFinalProject
//
//  Created by surinder pal singh sidhu on 2018-03-25.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class UpdatePostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    
    @IBAction func addPosts(_ sender: Any) {
        let newPost = Post(image: self.selectedImage!, caption: self.textView.text!)
        newPost.save()
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    @IBAction func pickImage(_ sender: Any) {
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
        
        self.present(actionsheet,animated: true,completion: nil)    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postUploaded" {
            let vc = segue.destination as! ViewController
            
       
        }
    }

    @IBAction func backButtonPresses(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
