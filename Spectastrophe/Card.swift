//
//  Card.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

struct Card: Equatable, Identifiable {
    let id = UUID()
    let parentId: UUID?
    let type: CardType
    let actions: [Action]
    let title: String
    let description: String

    init(parentId: UUID? = nil, type: CardType, title: String = "What does this card do?", description: String = "Nobody knows...", actions: [Action]) {
        self.parentId = parentId
        self.type = type
        self.actions = actions
        self.title = title
        self.description = description
    }

    // not sure if this is what I want this to be yet
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    enum CardType {
        case action, gear
    }
}
