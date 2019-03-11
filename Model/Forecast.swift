//
//  Forecast.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/11/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import Foundation

struct Forecast {
    var time : String
    var weather : Weather
    
    init(weather : Weather, time : String) {
        self.weather = weather
        self.time = time
    }
}
