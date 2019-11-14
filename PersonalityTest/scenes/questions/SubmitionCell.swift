//
//  SubmitionCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
final class SubmitionTableCell: UITableViewCell {
    override var reuseIdentifier: String? {
        return String(describing: self)
    }

    lazy var submitionView = SubmitionView(frame: self.bounds)
    func setData(submitted: Bool) {
        addSubview(submitionView)
        submitionView.equalToSuperViewEdges()
        backgroundColor = submitted ? UIColor.lightGray : UIColor.green
        isUserInteractionEnabled = !submitted
    }
}

final class SubmitionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
        backgroundColor = UIColor.darkGray
        let button = UILabel()
        button.textAlignment = .center
        button.text = "Submit All"
        addSubview(button)
        button.equalToSuperViewEdges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
