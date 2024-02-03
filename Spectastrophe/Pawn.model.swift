//
//  Pawn.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

final class Pawn: Targettable, HasDeck, ObservableObject {
    let id: UUID
    let type: PawnType

    @Published var hp: Int
    @Published var maxHp: Int
    @Published var tile: Coords?

    @Published var deck: Deck

    @Published var turnToPlay: Bool
    @Published var isMovingWith: ActionCard?
    @Published var isAttackingWith: ActionCard?

    init(_ type: PawnType = .enemy, maxHp: Int = 0, tile: Coords? = nil, deck: Deck = Deck()) {
        self.id = UUID()
        self.type = type
        self.hp = maxHp
        self.maxHp = maxHp
        self.tile = tile
        self.deck = deck
        self.turnToPlay = false
        self.isMovingWith = nil
        self.isAttackingWith = nil
    }

    enum PawnType {
        case player, enemy
    }

    func cancelMovementAction() {
        if let card = self.isMovingWith {
            self.deck.undoPlayFromHand(card)
            self.isMovingWith = nil
        }
    }

    func cancelAttackAction() {
        if let card = self.isAttackingWith {
            self.deck.undoPlayFromHand(card)
            self.isAttackingWith = nil
        }
    }
}
