//
//  TableViewCellDay.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/11/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit

class TableViewCellDay: UITableViewCell {

    
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var forecast : [Forecast] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TableViewCellDay : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let index = forecast[indexPath.item].time.components(separatedBy: " ")[1]
        switch index {
        case "00:00:00":
            cell.lbl.text = "0h\n"
        case "03:00:00":
            cell.lbl.text = "3h\n"
        case "06:00:00":
            cell.lbl.text = "6h\n"
        case "09:00:00":
            cell.lbl.text = "9h\n"
        case "12:00:00":
            cell.lbl.text = "12h\n"
        case "15:00:00":
            cell.lbl.text = "15h\n"
        case "18:00:00":
            cell.lbl.text = "18h\n"
        case "21:00:00":
            cell.lbl.text = "21h\n"
        default:
            print("")
        }
        cell.lbl.text! += "\(Int(forecast[indexPath.item].weather.temp - 273.0))ºC"
        let url = URL(string: "http://openweathermap.org/img/w/" + forecast[indexPath.item].weather.icon + ".png")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 10
        return CGSize(width: itemSize, height: collectionView.frame.height)
    }
}
