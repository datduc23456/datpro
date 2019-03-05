//
//  APIClient.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/5/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct APIClient{
    static let basePath = "http://api.openweathermap.org/data/2.5/weather?appid=87c241c1bb3f888025d126c77b395425"
    
    static func forecast (withLocation location: String,  completion : @escaping (Weather, Place) -> Void){
        let url = basePath + location

        Alamofire.request(url, method : .get).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progess) in
            print("")
        }.validate().responseJSON {
            response in
            let json = JSON(response.data ?? nil)
            var place : Place?
            var weather : Weather?
            if let name = json["name"].string, let id = json["id"].int, let jsonCoord = json["coord"].dictionaryObject {
                place = Place(id, name, jsonCoord)
                if let jsonW = json["weather"][0].dictionaryObject {
                    do {
                        //print("vao day")
                         let jsonG = json["wind"].dictionaryObject
                            
                        
                         let rain = json["rain"].dictionaryObject
                            
                        
                         let clouds = json["clouds"].dictionaryObject
                            
                        
                        weather = try? Weather(jsonW : jsonW, jsonG : jsonG!, rain : rain!, clouds: clouds!)
                        completion(weather!,place!)
                    } catch {
                        print("Error")
                    }
                }
            }
            
        }
    }
    
}
