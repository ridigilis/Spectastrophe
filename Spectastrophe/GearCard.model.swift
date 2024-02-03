//
//  GearCard.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/3/24.
//

import Foundation

struct GearCard: Card {
    let id: UUID
    let parentId: UUID? = nil
    let action: Action
    let title: String
    let description: String

    let slot: Deck.GearSlot
    let cards: [any Card]

    init(slot: Deck.GearSlot, title: String, description: String, cards: [any Card]) {
        let id = UUID()

        self.id = id
        self.slot = slot
        self.title = title
        self.description = description

        self.action = .equip(to: self.slot)

        self.cards = cards.map { card in
            ActionCard(parentId: id, title: card.title, description: card.description, action: card.action)
        }
    }
}
