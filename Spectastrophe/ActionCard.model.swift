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
    let rarity: Rarity
    let action: Action
    let title: String
    let description: String

    init(parentId: UUID? = nil, rarity: Rarity = .common, title: String = "What does this card do?", description: String = "Nobody knows...", action: Action) {
        self.parentId = parentId
        self.rarity = rarity
        self.action = action
        self.title = title
        self.description = description
    }
}
