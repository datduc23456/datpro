//
//  ViewController.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 2/26/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, UICollectionViewDataSource {
    

    @IBOutlet var addItem: UIView!
//    @IBOutlet weak var visual: UIVisualEffectView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var effect : UIVisualEffect!
    
    @IBOutlet weak var lbDo: NSLayoutConstraint!
    @IBOutlet weak var lbWeather: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    //        animateIn()
//    }
//
//    @IBAction func b(_ sender: Any) {
//        animateOut()
//    }
//
//    func animateIn (){
//        self.view.addSubview(addItem)
//        addItem.center = self.view.center
//        addItem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//        addItem.alpha = 0
//        UIView.animate(withDuration: 0.5, animations: { () in
//                self.visual.effect = self.effect
//                self.addItem.alpha = 1
//            self.addItem.transform = CGAffineTransform.identity
//        })
//    }
//    func animateOut() {
//        UIView.animate(withDuration: 0.5, animations: {() in
//            self.addItem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//            self.addItem.alpha = 0
//            self.visual.effect = nil
//            self.addItem.removeFromSuperview()
//        })
//
//    }
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "Main", bundle : nil)
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        footer.backgroundColor = .clear
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
//        effect = visual.effect
//        visual.effect = nil
        
        addItem.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view, typically from a nib.
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 5
        return CGSize(width: itemSize, height: itemSize)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        APIClient.forecast(withLocation: "&q=\(place.name!)") { weather,place1 in
            self.lbCity.text = place1.name
            print("\(weather.main)")
            self.lbWeather.text = weather.main
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
    
}
