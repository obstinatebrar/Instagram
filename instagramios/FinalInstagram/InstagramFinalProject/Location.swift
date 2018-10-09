//
//  Location.swift
//  
//
//  Created by surinder pal singh sidhu on 2018-04-02.
//


import Foundation
import SwiftyJSON
import UIKit
import Firebase
class Location {
    
    public var lat: String?
    public var long: String?
    public var distance: Double?
    public var name: String?
    //    init(name:String,lat:Double,long:Double, distance: Int)
    //    {
    //        self.name = name
    //        self.lat = lat
    //        self.long = long
    //        self.distance = distance
    //    }
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.lat = json["latitude"].stringValue
        self.long = json["longitude"].string
        
        self.name = json["name"].string
    }
    
    
}

