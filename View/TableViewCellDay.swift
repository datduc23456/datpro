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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let index = indexPath.item
        switch index {
        case 0:
            cell.lbl.text = "0h\n20ºC"
        case 1:
            cell.lbl.text = "3h\n20ºC"
        case 2:
            cell.lbl.text = "6h\n20ºC"
        case 3:
            cell.lbl.text = "9h\n20ºC"
        case 4:
            cell.lbl.text = "12h\n20ºC"
        case 5:
            cell.lbl.text = "15h\n20ºC"
        case 6:
            cell.lbl.text = "18h\n20ºC"
        case 7:
            cell.lbl.text = "21h\n20ºC"
        default:
            print("")
        }
        cell.imageView.image = #imageLiteral(resourceName: "10d")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 10
        return CGSize(width: itemSize, height: collectionView.frame.height)
    }
}
