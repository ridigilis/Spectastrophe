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
    @Published var bolsteredBy: Int
    @Published var op: Int
    @Published var maxOp: Int

    @Published var coords: Coords?

    @Published var deck: Deck

    @Published var turnToPlay: Bool
    @Published var isMovingWith: ActionCard?
    @Published var isAttackingWith: ActionCard?

    init(_ type: PawnType = .enemy, maxHp: Int = 0, tile: Coords? = nil, deck: Deck = Deck()) {
        self.id = UUID()
        self.type = type
        self.hp = maxHp
        self.maxHp = maxHp
        self.bolsteredBy = 0
        self.op = 0
        self.maxOp = 6
        self.coords = tile
        self.deck = deck
        self.turnToPlay = false
        self.isMovingWith = nil
        self.isAttackingWith = nil
    }
    
    init(_ type: PawnType) {
        self.type = type
        if type == .player {
            self.maxHp = 60
            self.coords = Coords(0,0)
            self.deck = Deck(drawPile: [
                GearCard(gear: Gear(slot: .wearable(.head))),
                GearCard(gear: Gear(slot: .wearable(.torso))),
                GearCard(gear: Gear(slot: .wearable(.hands))),
                GearCard(gear: Gear(slot: .wearable(.feet))),
                GearCard(gear: Gear(slot: .armament(.mainhand)))
            ])
            
            self.id = UUID()
            self.hp = 60
            self.bolsteredBy = 0
            self.op = 0
            self.maxOp = 6
            self.turnToPlay = false
            self.isMovingWith = nil
            self.isAttackingWith = nil
        } else {
            self.maxHp = 24
            self.coords = Coords(Int.random(in: -10...10), Int.random(in: -10...10))
            self.deck = Deck(drawPile: [
                GearCard(gear: Gear(slot: .wearable(.head))),
                GearCard(gear: Gear(slot: .wearable(.torso))),
                GearCard(gear: Gear(slot: .wearable(.hands))),
                GearCard(gear: Gear(slot: .wearable(.feet))),
                GearCard(gear: Gear(slot: .armament(.mainhand)))
            ])
            
            self.id = UUID()
            self.hp = 24
            self.bolsteredBy = 0
            self.op = 0
            self.maxOp = 6
            self.turnToPlay = false
            self.isMovingWith = nil
            self.isAttackingWith = nil
        }
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
