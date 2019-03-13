//
//  ViewController.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 2/26/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, UICollectionViewDataSource, CLLocationManagerDelegate {
    


    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTemp: UILabel!
    @IBOutlet var addItem: UIView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var effect : UIVisualEffect!
    var weather : Weather?
    var place: Place?
    var array : [Int] = []
    let locationManager : CLLocationManager = CLLocationManager()
    var location : CLLocation!
    @IBOutlet weak var lbDo: NSLayoutConstraint!
    @IBOutlet weak var lbWeather: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var locationAction = {
        
    }
    
    @IBAction func locationClicked(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .denied {
            let alertController = UIAlertController(title: "Location permissions", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            
        }
    }
    
    @IBAction func autocompleteClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.lbDate.text = result
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        footer.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
//        effect = visual.effect
//        visual.effect = nil
    }
    
   
    
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            location = locationManager.location
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath as IndexPath) as! myCell
        let photos = ["wind-icon","clouds-icon","rain-icon","humidity-icon"]
        cell.imageView.image = UIImage(named:photos[indexPath.item])
        if self.weather != nil {
            let index = indexPath.item
            switch (index) {
            case 0:
                var string = ""
                if weather!.wind!["speed"] != nil {
                    string = "   speed: " + "\((weather!.wind!["speed"])!)"
                }
                if weather!.wind!["deg"] != nil {
                    string += "\n   deg: " + "\((weather!.wind!["deg"])!)"
                }
                //cell.lbInfor.frame.origin.x += 20
                cell.lbInfor.text = string
            case 1:
                let string = "   clouds: " + "\((weather!.clouds!["all"])!)"
                cell.lbInfor.text = string
            case 2:
                var string : String = "None"
                if let rain = weather?.rain {
                    if rain.count > 0 {
                        string = ""
                        for key in rain.keys {
                            string += key + ": \(String(describing: rain[key]!))"
                        }
                        cell.lbInfor.text = string
                    }
                }
                cell.lbInfor.text = string
            case 3:
                let string = "   humidity:" + "\(Int(weather!.humidity))"
                cell.lbInfor.text = string
            default:
                print("")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 5
        return CGSize(width: itemSize, height: itemSize)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        APIClient.forecast(withLocation: place.name!) { weather,place1 in
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func checkDupicateId (_ locationId : Int) -> Bool {
        return array.lastIndex(of: locationId) != nil
    }

    func updateUI (_ weather : Weather , _ place : Place) {
        self.lbCity.text = place.name
        self.lbWeather.text = weather.main
        self.lbTemp.text = "\(weather.temp - 273.0)"
        self.place = place
        self.weather = weather
        self.collectionView.reloadData()
        UserDefaults.standard.set("\(place.id)", forKey: "place")
        switch weather.description {
        case "clear sky":
            self.imageView.image = UIImage(named: "sun")
        case "few clouds" , "scattered clouds" , "broken clouds":
            self.imageView.image = UIImage(named: "cloudy")
        case "shower rain" , "rain":
            self.imageView.image = UIImage(named: "rain")
        case "thunderstorm":
            self.imageView.image = UIImage(named: "storm")
        case "snow":
            self.imageView.image = UIImage(named: "snow")
        default:
            self.imageView.image = UIImage(named: "cloudy")
        }
    }
}

