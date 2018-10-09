//
//  PostSearchTableViewController.swift
//  InstagramFinalProject
//
//  Created by Surinder Kahlon on 2018-03-31.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase
class PostSearchTableViewController: UITableViewController,UISearchResultsUpdating {
    
    
    var id = String()
    var posts = [Post]()
    var postsArray = [NSDictionary?]()
    var filteredPosts = [NSDictionary?]()
    var databaseRef =  Database.database().reference()
    @IBOutlet var tableview: UITableView!
    let searchController = UISearchController(searchResultsController:nil)
     let uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        print("aaaaabbbbbbbb")
        print(uid)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
            self.databaseRef.child("users").child(self.uid!).child("posts").queryOrdered(byChild: "caption").observe(.childAdded, with: { (snapshot) in
                self.postsArray.append(snapshot.value as? NSDictionary)
                
                self.tableview.insertRows(at: [IndexPath(row:self.postsArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
                
            }) {(error) in
                print(error.localizedDescription)
            }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPosts.count
        }
        
        return self.postsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post : NSDictionary?
        if searchController.isActive && searchController.searchBar.text != "" {
            post = filteredPosts[indexPath.row]
        }
        else {
            post = self.postsArray[indexPath.row]
        }
        cell.textLabel?.text = post?["caption"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "OpenImageViewController") as! OpenImageViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
         let post : NSDictionary?
        post = filteredPosts[indexPath.row]
        let image = post?["imageDownloadURL"] as? String
         let caption = post?["caption"] as? String
        vc.imageDownloadoadingURL = image!
        vc.captionText = caption!
        self.navigationController?.pushViewController(vc, animated: true)
        appDelegate.window?.rootViewController = vc
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    func filterContent(searchText:String) {
        self.filteredPosts = self.postsArray.filter { user in
            let tag = user!["caption"] as? String
            return(tag?.lowercased().contains(searchText.lowercased()))!
        }
        tableview.reloadData()
    }
}
