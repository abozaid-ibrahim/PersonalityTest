//
//  QuestionTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class QuestionTableCell: UITableViewCell {
        @IBOutlet private var nameLbl: UILabel!

        func setData(_ model: Question) {
            nameLbl.text = model.question
        }

        override func awakeFromNib() {
            super.awakeFromNib()
            selectionStyle = .gray
        }
    }
