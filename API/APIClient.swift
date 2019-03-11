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
    static let basePath = "http://api.openweathermap.org/data/2.5/weather"
    static let basePath1 = "http://api.openweathermap.org/data/2.5/group"
    static let basePath2 = "http://api.openweathermap.org/data/2.5/forecast"
    
    static func forecastFor (withLocation location: String, completion : @escaping ([Forecast]) -> Void) {
        let parameters: Parameters = [
            "q": location,
            "appid" : "87c241c1bb3f888025d126c77b395425"
        ]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(basePath2, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)){
            progess in print("")
            }.validate().responseJSON{
                response in
                let json = JSON(response.data ?? nil)
                let cod = json["cod"].string
                if cod == "200" {
                    let count = json["cnt"].int ?? 0
                    var json1 = JSON(json["list"])
                    for i in 0..<count {
                        
                    }
                }
        }
    }
    
    static func forecast (withLocation location: String,  completion : @escaping (Weather, Place) -> Void){
        let parameters: Parameters = [
            "q": location,
            "appid" : "87c241c1bb3f888025d126c77b395425"
        ]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(basePath, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progess) in
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
                         let jsonG = json["wind"].dictionaryObject
                        
                         let rain = json["rain"].dictionaryObject
                        
                         let clouds = json["clouds"].dictionaryObject
                            
                         let main = json["main"].dictionaryObject
                        
                        weather = try Weather(jsonW : jsonW, jsonG : jsonG ?? [:], rain : rain ?? [:], clouds: clouds ?? [:], jsonM : main ?? [:])
                        completion(weather!,place!)
                    } catch {
                        print("Error")
                    }
                }
            }
            
        }
    }
    
    static func forecastList (withLocation location: String, completion: @escaping ([Weather], [Place]) -> Void) {
        
        let parameters: Parameters = [
            "id": location,
            "appid" : "87c241c1bb3f888025d126c77b395425"
        ]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(basePath1, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: {
            progess in
            print("")
        }).validate().responseJSON{
            response in
            let json = JSON(response.data ?? nil)
            var places : [Place] = []
            var weathers : [Weather] = []
            let count = json["cnt"].int ?? 0
                var place : Place?
                var weather : Weather?
                var json1 = JSON(json["list"])
                for i in 0..<count {
                if let name = json1[i]["name"].string, let id = json1[i]["id"].int, let jsonCoord = json1[i]["coord"].dictionaryObject {
                    place = Place(id, name, jsonCoord)
                    if let jsonW = json1[i]["weather"][0].dictionaryObject {
                        do {
                            let jsonG = json1[i]["wind"].dictionaryObject
                            
                            let rain = json1[i]["rain"].dictionaryObject
                            
                            let clouds = json1[i]["clouds"].dictionaryObject
                            
                            let main = json1[i]["main"].dictionaryObject
                            
                            weather = try Weather(jsonW : jsonW, jsonG : jsonG ?? [:], rain : rain ?? [:], clouds: clouds ?? [:], jsonM : main ?? [:])
                            places.append(place!)
                            weathers.append(weather!)
                            completion(weathers,places)
                        } catch {
                            print("Error")
                        }
                    }
                }
                }
            
        }
        
    }
    
}
