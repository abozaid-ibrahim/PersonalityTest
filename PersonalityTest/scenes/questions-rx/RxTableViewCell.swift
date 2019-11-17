//
//  RxTableViewCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class RxTableViewCell: UITableViewCell {
    @IBOutlet var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
