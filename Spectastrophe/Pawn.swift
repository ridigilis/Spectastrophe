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
    @Published var tile: Coords?
    @Published var moves: UInt

    @Published var deck: Deck

    @Published var turnToPlay: Bool
    @Published var isMoving: Bool
    @Published var isAttacking: Bool
    @Published var isAttackingWith: Action?

    init(_ type: PawnType = .enemy, hp: Int = 0, tile: Coords? = nil, moves: UInt = 0, deck: Deck = Deck()) {
        self.id = UUID()
        self.type = type
        self.hp = hp
        self.tile = tile
        self.moves = moves
        self.deck = deck
        self.turnToPlay = false
        self.isMoving = false
        self.isAttacking = false
        self.isAttackingWith = nil
    }

    enum PawnType {
        case player, enemy
    }
}

protocol Targettable: Identifiable {
    var id: UUID { get }
    var hp: Int { get set }
    var tile: Coords? { get set }
    var moves: UInt { get set }
}

protocol HasDeck {
    var deck: Deck { get set }
}
