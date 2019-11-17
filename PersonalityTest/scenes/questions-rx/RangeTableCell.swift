//
//  RangeTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit
import RxSwift

class RangeTableCell: UITableViewCell {
    @IBOutlet var slider: UISlider!
       @IBOutlet private var titleLbl: UILabel!
       @IBOutlet private var valueLbl: UILabel!
       private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
