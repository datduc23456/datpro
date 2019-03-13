//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by dat.nguyenquoc on 3/6/19.
//  Copyright © 2019 dat.nguyenquoc. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate : AnyObject {
    func remove (placeId : Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    var placeId : Int?
    weak var delegate : TableViewCellDelegate?
    var array : [Int] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        if let array = UserDefaults.standard.array(forKey: "places") as? [Int] {
            self.array = array
        }
    }

    @IBOutlet weak var btnRemove: UIButton!
    @IBAction func btnRemove(_ sender: Any) {
        if let delegate = self.delegate as? TableViewController {
            delegate.remove(placeId : placeId!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btnRemove.layer.cornerRadius = 4
        // Configure the view for the selected state
    }

}

