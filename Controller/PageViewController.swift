//
//  PageViewController.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/11/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit
import GooglePlaces

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBAction func confirmClicked(_ sender: Any) {
        if place != nil {
            if let array = UserDefaults.standard.array(forKey: "places") as? [Int] {
                self.array = array
            }
            if !checkDupicateId(place!.id!){
                self.array.append(place!.id!)
                UserDefaults.standard.set(array, forKey: "places")
            }
        }
        animateOut()
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
        }
    }
    @IBAction func addPlace(_ sender: Any) {
        animateIn()
    }
    var place: Place?
    @IBOutlet var addItem: UIView!
    var vc1 : UIViewController?
    var vc2 : UIViewController?
    var array : [Int] = []
    @IBAction func cancelClicked(_ sender: Any) {
        animateOut()
    }
    
    
    
    func animateIn (){
        
        self.view.addSubview(addItem)
        
        addItem.center = self.view.center
        addItem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItem.alpha = 1
        //        UIView.animate(withDuration: 0.5, animations: { () in
        //                self.visual.effect = self.effect
        //                self.addItem.alpha = 1
        //            self.addItem.transform = CGAffineTransform.identity
        //        })
    }
    func animateOut() {
        UIView.animate(withDuration: 0.5, animations: {() in
            self.addItem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItem.alpha = 0
            //self.visual.effect = nil
            self.addItem.removeFromSuperview()
        })
        
    }
    
    
    @IBAction func autocomplete(_ sender: Any) {
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
    var pageControl = UIPageControl()
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    lazy var arrayViewControllers: [UIViewController] = {
        vc1 = self.newVc(viewController: "vc1")
        vc2 = self.newVc(viewController: "vc2")
        return [vc1!,
                vc2!]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return arrayViewControllers.last
        }
        
        guard arrayViewControllers.count > previousIndex else {
            return nil
        }
         return arrayViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        let count = arrayViewControllers.count
        
//        guard count != nextIndex else {
//            return arrayViewControllers.first
//        }
        
        guard count > nextIndex else {
            return nil
        }
        return arrayViewControllers[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = arrayViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
        }
        configurePageControl()
        addItem.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
        
        func configurePageControl() {
            // The total number of pages that are available is based on how many available colors we have.
            pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
            self.pageControl.numberOfPages = arrayViewControllers.count
            self.pageControl.currentPage = 0
            self.pageControl.tintColor = UIColor.black
            self.pageControl.pageIndicatorTintColor = UIColor.white
            self.pageControl.currentPageIndicatorTintColor = UIColor.black
            self.view.addSubview(pageControl)
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = arrayViewControllers.index(of: pageContentViewController)!
    }
}

extension PageViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        if let vcMain = vc1 as? ViewController {
        APIClient.forecast(withLocation: place.name!) { weather,place1 in
            vcMain.lbCity.text = place1.name
            vcMain.lbWeather.text = weather.description
            vcMain.weather = weather
            self.place = place1
            vcMain.lbTemp.text = "\(Int(weather.temp - 273))"
            vcMain.collectionView.reloadData()
            UserDefaults.standard.set("\(place1.id!)", forKey: "place")
            }
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
    
}
