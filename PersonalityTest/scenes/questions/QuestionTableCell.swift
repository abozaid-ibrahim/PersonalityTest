//
//  QuestionTableCell.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import AIFlatSwitch
import RxSwift
import UIKit

final class QuestionTableCell: UITableViewCell {
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var chooseAnswer: AIFlatSwitch!
    private(set) var disposeBag = DisposeBag()
    var answerChanged: Observable<Bool> {
        _answerClicked.asObservable()
    }

    var _answerClicked = PublishSubject<Bool>()
    @IBAction func answerChanged(_ sender: AIFlatSwitch) {
        _answerClicked.onNext(sender.isSelected)
    }

    func setData(_ model: String) {
        nameLbl.text = model
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        disposeBag = DisposeBag()
    }
}
