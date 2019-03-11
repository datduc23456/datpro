//
//  ViewControllerDay.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/11/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit

class ViewControllerDay: UIViewController {

    @IBOutlet weak var tableViewDay: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDay.dataSource = self
        tableViewDay.delegate = self
        tableViewDay.backgroundColor = UIColor.clear
    }
}

extension ViewControllerDay : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDay", for: indexPath) as! TableViewCellDay
        return cell
    }
    
    

    
}
