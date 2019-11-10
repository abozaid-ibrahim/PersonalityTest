//
//  TableViewEditingCommand.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum TableViewEditingCommand {
    case AppendItem(item: QuestionSectionModel, section: Int)
    case answerQuestion
    case DeleteItem(IndexPath)
}

// This is the part

struct SectionedTableViewState {
     var sections: [QuestionSectionModel]

    init(sections: [QuestionSectionModel]) {
        self.sections = sections
    }

    func execute(command: TableViewEditingCommand) -> SectionedTableViewState {
        switch command {
        case .AppendItem(let appendEvent):
            var sections = self.sections
            let items = sections[appendEvent.section].items // + appendEvent.item
//            sections[appendEvent.section] = NumberSection(original: sections[appendEvent.section], items: items)
            return SectionedTableViewState(sections: sections)
        case .DeleteItem(let indexPath):
            var sections = self.sections
            var items = sections[indexPath.section].items
            items.remove(at: indexPath.row)
//            sections[indexPath.section] = NumberSection(original: sections[indexPath.section], items: items)
            return SectionedTableViewState(sections: sections)

        case .answerQuestion:
            var sections = self.sections
            return SectionedTableViewState(sections: sections)
        }
    }
}

func + <T>(lhs: [T], rhs: T) -> [T] {
    var copy = lhs
    copy.append(rhs)
    return copy
}
