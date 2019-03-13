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
    var forecast : [String : [Forecast]] = [:]
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDay.dataSource = self
        tableViewDay.delegate = self
        tableViewDay.backgroundColor = UIColor.clear
        if #available(iOS 10.0, *) {
            self.tableViewDay.refreshControl = refreshControl
        } else {
            self.tableViewDay.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        self.refreshControl.tintColor = UIColor.lightGray
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data...", attributes: attributes)
    }
    
    @objc private func updateData() {
        self.tableViewDay.reloadData()
        self.refreshControl.endRefreshing()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        tableViewDay.reloadData()
//    }
}

extension ViewControllerDay : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDay", for: indexPath) as! TableViewCellDay
        let index = indexPath.item
        print("\(self.forecast[Array(forecast.keys)[index]]!)")
        cell.lblDay.text = Array(forecast.keys)[index]
        cell.forecast = self.forecast[Array(forecast.keys)[index]]!
        cell.collectionView.reloadData()
        return cell
    }
}
