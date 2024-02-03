//
//  Card.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

protocol Card: Identifiable {
    var id: UUID { get }
    var parentId: UUID? { get }

    var action: Action { get }

    var title: String { get }
    var description: String { get }
}

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
