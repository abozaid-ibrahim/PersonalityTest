//
//  TableViewEditingCommand.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
final class TableViewEditingCommand {
    func itemSelected(questions: [QuestionSectionModel], index: IndexPath) -> [QuestionSectionModel] {
        var sections = questions
        let section = sections[index.section]
        var options = section.items
        let item = options[index.row]
        //        item.setName("Selected")
        options[index.row] = item

        if let selectable = item as? SelectableAnswerModel,
            let model = selectable.conditional {
            options.append(model)
        }
        if !section.answered {
            options.append(SubmitButtonModel(sectionId: item.sectionId))
        }
        sections[index.section] = QuestionSectionModel(question: section.question, items: options, answered: true)
        return sections
    }

    func itemDeSelected(questions: [QuestionSectionModel], index: IndexPath) -> [QuestionSectionModel] {
        var sections = questions
        let section = sections[index.section]
        var options = section.items
        let item = options[index.row]
        //        item.setName("Selected")
        options[index.row] = item

        if let selectable = item as? SelectableAnswerModel,
            let model = selectable.conditional {
            options.append(model)
        }
        if section.answered {
            options.removeLast()
        }
        sections[index.section] = QuestionSectionModel(question: section.question, items: options, answered: false)
        return sections
    }
}
