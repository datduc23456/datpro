//
//  Place.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/5/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import Foundation

struct Coord {
    var longtitude: Double?
    var latitude: Double?
    
    init(json:[String:Any]){
        if let longtitude = json["lon"] as? Double, let latitude = json["lat"] as? Double{
            self.longtitude = longtitude
            self.latitude = latitude
        }
    }
}
struct Place {
    var id : Int?
    var name : String?
    var coord : Coord?
    
    init(_ id : Int, _ name : String, _ jsonCoord : [String : Any]) {
        self.id = id
        self.name = name
        self.coord = Coord(json: jsonCoord)
    }
    
}
