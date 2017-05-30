//
//  RentalTableViewCell.swift
//  RSRVR
//
//  Created by Casper Biemans on 30-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class RentalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carPerformance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
