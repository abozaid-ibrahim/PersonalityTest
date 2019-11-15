//
//  ImageCheckRow.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Eureka
import Foundation
import UIKit

final class ImageCheckRow<T: Equatable>: Row<ImageCheckCell<T>>, SelectableRowType, RowType {
    var selectableValue: T?
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

final class ImageCheckCell<T: Equatable>: Cell<T>, CellType {
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Image for selected state
    lazy var trueImage: UIImage = {
        UIImage(named: "selected")!
    }()

    /// Image for unselected state
    lazy var falseImage: UIImage = {
        UIImage(named: "unselected")!
    }()

    override func update() {
        super.update()
        checkImageView?.image = row?.value != nil ? trueImage : falseImage
        checkImageView?.sizeToFit()
    }

    /// Image view to render images. If `accessoryType` is set to `checkmark`
    /// will create a new `UIImageView` and set it as `accessoryView`.
    /// Otherwise returns `self.imageView`.
    public var checkImageView: UIImageView? {
        guard accessoryType == .checkmark else {
            return imageView
        }

        guard let accessoryView = accessoryView else {
            let imageView = UIImageView()
            self.accessoryView = imageView
            return imageView
        }

        return accessoryView as? UIImageView
    }

    override func setup() {
        super.setup()
        accessoryType = .none
    }

    override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }
}
