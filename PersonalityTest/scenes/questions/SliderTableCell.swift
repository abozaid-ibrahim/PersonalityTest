//
//  SliderTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/15/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Eureka
import RxSwift
import UIKit

open class SliderTableCell: Cell<Bool>, CellType {
    @IBOutlet var slider: UISlider!
    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var valueLbl: UILabel!
    private var disposeBag = DisposeBag()
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        editingAccessoryView = accessoryView
    }

    func setData(min: Float, max: Float, title: String?) {
        titleLbl.text = title
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = min
        valueLbl.text = String(min)
        slider.rx.value.map { String($0) }.bind(to: valueLbl.rx.text).disposed(by: disposeBag)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    open override func setup() {
        super.setup()
        selectionStyle = .none
    }

    open override func update() {
        super.update()
    }
}

// MARK: SwitchRow

open class _OptionSliderRow: Row<SliderTableCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

/// Boolean row that has a UISwitch as accessoryType
public final class OptionSliderRow: _OptionSliderRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
