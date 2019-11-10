//
//  CategoryTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class CategoryTableCell: UITableViewCell {
    @IBOutlet private var nameLbl: UILabel!

    func setData(_ model: Category) {
        nameLbl.text = model.rawValue
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
    }
}
