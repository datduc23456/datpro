//
//  Weather.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/4/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Weather {
    var id : Int
    var main : String
    var description : String
    var icon : String
    var wind : [String : Any]?
    var rain : [String : Any]?
    var clouds : [String : Any]?
    var temp : Double
    var humidity : Double
    
    enum error : Error{
        case missing(String)
        case invalid(String, Any)
    }
    init (jsonW:[String:Any], jsonG : [String : Any], rain : [String : Any], clouds : [String : Any], jsonM : [String : Any]) throws {
        guard let id = jsonW["id"]  as? Int else {
            throw error.missing("Missing id")
        }
        guard let main = jsonW["main"] as? String else {
            throw error.missing("Missing Main")
        }
        guard let description = jsonW["description"] as? String else {
            throw error.missing("Missing description")
        }
        guard let icon = jsonW["icon"] as? String else {
            throw error.missing("Missing icon")
            
        }
        guard let temp = jsonM["temp"] as? Double else {
            throw error.missing("Missing temp")
            
        }
        guard let humidity = jsonM["humidity"] as? Double else {
            throw error.missing("Missing humidity")
            
        }
        self.rain = rain
        self.clouds = clouds
        self.wind = jsonG
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.humidity = humidity
    }
    
}
