//
//  MyPageView.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 2/28/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit

class MyPageView: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let collectView : [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
       	return [
            sb.instantiateViewController(withIdentifier: "vc1"),
        sb.instantiateViewController(withIdentifier: "vc1")
        ]
        
    }()
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let current : Int = collectView.index(of : viewController) ?? 0
        if current == 0 {
            return collectView[0]
        } else {
            return collectView[1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let current : Int = collectView.index(of : viewController) ?? 0
        if current == 0 {
            return collectView[1]
        } else {
            return collectView[0]
        }
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
