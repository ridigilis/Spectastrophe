//
//  ActionCard.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/3/24.
//

import Foundation

struct ActionCard: Card {
    let id = UUID()
    let parentId: UUID?
    let rarity: Rarity?
    let primaryAction: Action?
    let range: [Action.Range]?
    let title: String
    let description: String

    init(parentId: UUID? = nil, rarity: Rarity? = nil, title: String = "What does this card do?", description: String = "Nobody knows...", primaryAction: Action, range: [Action.Range]? = nil) {
        self.parentId = parentId
        self.rarity = rarity
        self.primaryAction = primaryAction
        self.range = range
        self.title = title
        self.description = description
    }
}
