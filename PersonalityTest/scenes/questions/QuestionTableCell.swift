//
//  QuestionTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit
final class QuestionTableCell: UITableViewCell {
    @IBOutlet private var nameLbl: UILabel!

    func setData(_ model: String) {
        nameLbl.text = model
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
    }
}
