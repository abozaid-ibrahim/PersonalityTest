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

public final class ImageCheckRow<T: Equatable>: Row<ImageCheckCell<T>>, SelectableRowType, RowType {
    public var selectableValue: T?
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class ImageCheckCell<T: Equatable>: Cell<T>, CellType {
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Image for selected state
    public lazy var trueImage: UIImage = {
        UIImage(named: "selected")!
    }()

    /// Image for unselected state
    public lazy var falseImage: UIImage = {
        UIImage(named: "unselected")!
    }()

    public override func update() {
        super.update()
        checkImageView?.image = row?.value != nil ? trueImage : falseImage
        checkImageView?.sizeToFit()
    }

    /// Image view to render images. If `accessoryType` is set to `checkmark`
    /// will create a new `UIImageView` and set it as `accessoryView`.
    /// Otherwise returns `self.imageView`.
    open var checkImageView: UIImageView? {
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

    public override func setup() {
        super.setup()
        accessoryType = .none
    }

    public override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }
}
