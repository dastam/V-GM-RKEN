////
////  CatTableViewCell.swift
////  Vägmärken
////
////  Created by Arman Dadmand on 2017-11-03.
////  Copyright © 2017 Arman Dadmand. All rights reserved.
////
//
import UIKit

class CatTableViewCell: UITableViewCell {

    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var signLabel: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

