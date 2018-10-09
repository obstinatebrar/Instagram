//
//  ViewController.swift
//  nearbyFriends
//
//  Created by surinder pal singh sidhu on 2018-03-30.
//  Copyright © 2018 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import SwiftyJSON

class mapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var mycoordinate :CLLocation!
    var myLatitude: String!
    var myLongitude: String!
 
    var locations = [Location] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the current region for the map (fairview mall)
      
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            //  print(snapshot)
            //   print(snapshot.childrenCount)
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.myLatitude = dictionary["latitude"] as? String
                
                  self.myLongitude = dictionary["longitude"] as? String
             
                self.mycoordinate = CLLocation(latitude: Double(self.myLatitude)!, longitude: Double(self.myLongitude)!)
               self.setMap()
            }
            
            
        }, withCancel: nil)
        
    
        
        ///////////////////////////////////////////////////////////////////////////
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            let newPost = Location(snapshot: snapshot)
         
           
            DispatchQueue.main.async {
                self.locations.append(newPost)
               self.printLocation()
                
                
            }
               
                
                
            
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func printLocation(){
        
        print("the count of all the locations\(locations.count)")
        for location in self.locations{
            var distance = self.mycoordinate.distance(from: CLLocation(latitude: Double(location.lat!)!,longitude: Double(location.long!)!))
            location.distance = distance
       
            
        }
        
        let newlocations =  self.locations.sorted(by: { $0.distance! < $1.distance!
            
        })
        
        
        
        for location in newlocations {
            
           
            // add a pin to the map
            
            // 1. Create a new Pin object
            let pin = MKPointAnnotation()
            
            // 2. Set the coordinate of the pin
            // In this example, we set to 43.7779, -79.3447
            let coordinate = CLLocationCoordinate2DMake(Double(location.lat!)!, Double(location.long!)!)
            pin.coordinate = coordinate
            
            // 3. Set the .title property if you want a "popup"
            // when you click on the pin.
            pin.title = location.name
            
            // 4. Add the pin to the map.
            self.mapView.addAnnotation(pin)
            
            
            
        }
        
    }
    func setMap(){
        
        let coord = CLLocationCoordinate2DMake(Double(myLatitude)!, Double(myLongitude)!)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(coord, span)
        mapView.setRegion(region, animated: true)
        
    }
}


