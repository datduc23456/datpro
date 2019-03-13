//
//  TableViewController.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/4/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var placeId : [Any]?
    var weather : [Weather] = []
    var places : [Place] = []
    var placeIdRemove : Int = -1
    var array : [Int] = []
    @IBOutlet var removeView: UIView!
    @IBOutlet var removePlace: UIView!
    @IBOutlet weak var tableView: UITableView!
    func callApi() {
        
            if let array = UserDefaults.standard.array(forKey: "places") as? [Int] {
                self.array = array
            }
            for i in 0..<array.count {
                if placeIdRemove == array[i] {
                    array.remove(at: i)
                    UserDefaults.standard.set(array, forKey: "places")
                    break
                }
            }
        
        if let array = UserDefaults.standard.array(forKey: "places") as? [Int] {
            self.array = array
        }
        var location = ""
        for id in array {
            location += "\(id),"
        }
        if !location.isEmpty{
            location.remove(at: location.index(before: location.endIndex))
        }
        
        APIClient.forecastList(withLocation: location){
            weathers,places in
            self.weather = weathers
            self.places = places
            self.tableView.reloadData()
        }
        if self.array.isEmpty {
            self.places.removeAll()
            self.tableView.reloadData()
        }
    }
    @IBAction func confirmBtn(_ sender: Any) {
        callApi()
        animateOut()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        animateOut()
    }
    
    
    func animateIn (){
        
        self.view.addSubview(removePlace)
        
        removePlace.center = self.view.center
        removePlace.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        removePlace.alpha = 1
        //        UIView.animate(withDuration: 0.5, animations: { () in
        //                self.visual.effect = self.effect
        //                self.addItem.alpha = 1
        //            self.addItem.transform = CGAffineTransform.identity
        //        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.5, animations: {() in
            self.removePlace.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.removePlace.alpha = 0
            //self.visual.effect = nil
            self.removePlace.removeFromSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.removeView.layer.cornerRadius = 5
        callApi()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL1", for: indexPath) as! TableViewCell
        cell.lblCity.text = places[indexPath.item].name
        cell.lblInfo.text = weather[indexPath.item].description + " \(Int(weather[indexPath.item].temp - 273))ºC"
        cell.placeId = places[indexPath.item].id
        cell.delegate = self
        let url = URL(string: "http://openweathermap.org/img/w/" + weather[indexPath.item].icon + ".png")
        DispatchQueue.global().async {
        let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
        cell.imgWeather.image = UIImage(data: data!)
            }
        }
        return cell
        
    }
}

extension TableViewController : TableViewCellDelegate {
    func remove(placeId : Int) {
        self.placeIdRemove = placeId
        animateIn()
    }
}
