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
    
    enum error : Error{
        case missing(String)
        case invalid(String, Any)
    }
    init (jsonW:[String:Any], jsonG : [String : Any], rain : [String : Any], clouds : [String : Any]) throws {
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
        self.rain = rain
        self.clouds = clouds
        self.wind = jsonG
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    static let basePath = "http://api.openweathermap.org/data/2.5/weather"
    // completion : @escaping ([Weather]) -> ()
    static func forecast (withLocation location: String, completion: @escaping ([Weather]) -> ()){
        let url = basePath + location
        let request = URLRequest.init(url: URL(string: url)!)
//        let task = URLSession.shared.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
//            var result : [Weather] = []
//            if let data = data {
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
//                        if let weathers = json["weather"] as? [[String:Any]] {
//                            for a in weathers {
//                                if let weather = try? Weather(json: a){
//                                    result.append(weather)
//                                }
//                            }
//                        }
//                    }
//                } catch {
//
//                }
//                completion(result)
//            } else {
//                print("Error")
//            }
//        }
//            task.resume()
        
//        Alamofire.request(url).downloadProgress(queue: DispatchQueue.global(qos: .utility)) {
//            progess in
//            print("\(progess.fractionCompleted)")
//            } .validate().responseJSON {
//                response in
//                var weathers : [Weather] = []
//                if let json = response.result.value as? [String : Any]{
//                    if let jsonWeather = json["weather"] as? [[String : Any]] {
//                        for i in jsonWeather {
//                            if let weather = try? Weather(json : i){
//                                weathers.append(weather)
//                            }
//                        }
//                    }
//                    completion(weathers)
//                }
//                else {
//
//                }
//        }
//    }
//        Alamofire.request(url, method : .get).downloadProgress(queue: DispatchQueue.global(qos: .utility)){
//            progess in
//            print("\(progess.fractionCompleted)")
//            } .validate().responseJSON() {
//                response in
//                var weathers : [Weather] = []
//                let json1 = JSON(response.data)
//                if let main = json1["weather"][0]["id"].int {
//                    print("\(main)")
//                }
//
//                if let json = response.result.value as? [String : Any] {
//                    if let jsonWeather = json["weather"] as? [[String : Any]]{
//                        for i in jsonWeather {
//                            if let weather = try? Weather(json: i){
//                                weathers.append(weather)
//                            }
//                        }
//                    }
//                    completion(weathers)
//                }
//        }
//    }
    }
}
