//
//  DistanceTableViewCell.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/5/19.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {
    
    @IBOutlet var stationNameLabel : UILabel!
    @IBOutlet var distanceNameLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
