//
//  Deck.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

final class Deck: ObservableObject {
    @Published var drawPile: [any Card]
    @Published var hand: [any Card]
    @Published var playArea: [any Card]
    @Published var discardPile: [any Card]
    @Published var exhaustPile: [any Card]

    @Published var equipment: Equipment

    init(drawPile: [any Card] = [],
         hand: [any Card] = [],
         playArea: [any Card] = [],
         discardPile: [any Card] = [],
         exhaustPile: [any Card] = [],
         equipment: Equipment = Equipment()
    ) {
        self.equipment = equipment

        let cardsFromHeadSlot = equipment.head?.cards ?? []
        let cardsFromTorsoSlot = equipment.torso?.cards ?? []
        let cardsFromFeetSlot = equipment.feet?.cards ?? []
        let cardsFromHandsSlot = equipment.hands?.cards ?? []

        let initialDrawPile = drawPile + cardsFromHeadSlot + cardsFromTorsoSlot + cardsFromFeetSlot + cardsFromHandsSlot


        self.drawPile = initialDrawPile.shuffled()
        self.hand = hand
        self.playArea = playArea
        self.discardPile = discardPile
        self.exhaustPile = exhaustPile

    }

    private func drawCardFromTop() {
        let card = self.drawPile.first

        self.drawPile = self.drawPile.filter { $0.id != card?.id }
        self.hand = self.hand + [card].compactMap { $0 }
    }

    func draw(_ amt: UInt = 1) {
        for _ in 1...amt {
            if self.drawPile.count == 0 {
                self.shuffleDiscardPileIntoDrawPile()
            }
            self.drawCardFromTop()
        }
    }

    func playFromHand(_ card: any Card) {
        self.hand = self.hand.filter { $0.id != card.id }
        self.playArea = self.playArea + [card].compactMap { $0 }
    }

    func undoPlayFromHand(_ card: any Card) {
        self.playArea = self.playArea.filter { $0.id != card.id }
        self.hand = self.hand + [card].compactMap { $0 }
    }

    func discardFromHand(_ card: any Card) {
        self.hand = self.hand.filter { $0.id != card.id }
        self.discardPile = self.discardPile + [card].compactMap{ $0 }
    }

    func exhaust(_ card: any Card) {
        self.playArea = self.playArea.filter { $0.id != card.id }
        self.exhaustPile = self.exhaustPile + [card].compactMap{ $0 }
    }

    func shuffleDrawPile() {
        self.drawPile = self.drawPile.shuffled()
    }

    func shuffleDiscardPileIntoDrawPile() {
        let cards = self.drawPile + self.discardPile

        self.drawPile = cards.shuffled()
        self.discardPile = []
    }

    func discardHand() {
        self.discardPile = self.discardPile + self.hand
        self.hand = []
    }

    func clearPlayArea() {
        self.discardPile = self.discardPile + self.playArea
        self.playArea = []
    }

    enum GearSlot {
        case head
        case torso
        case feet
        case hands
    }

    final class Equipment: ObservableObject {
        @Published var head: GearCard?
        @Published var torso: GearCard?
        @Published var feet: GearCard?
        @Published var hands: GearCard?

        init(
            head: GearCard? = nil,
            torso: GearCard? = nil,
            feet: GearCard? = GearCard(slot: .feet, title: "Common Boots", description: "Adds 2 Move to deck", cards: [
                ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
                ActionCard(title: "Move", description: "Move to an adjacent space", action: .movement(for: .constant(1))),
            ]),
            hands: GearCard? = GearCard(slot: .hands, title: "Common Sword", description: "Adds 4 Pierce to deck", cards: [
                ActionCard(title: "Pierce", description: "Damage an adjacent enemy for 1d4", action: .attack(.physical(.pierce), for: .random([.d4]))),
                ActionCard(title: "Pierce", description: "Damage an adjacent enemy for 1d4", action: .attack(.physical(.pierce), for: .random([.d4]))),
                ActionCard(title: "Pierce", description: "Damage an adjacent enemy for 1d4", action: .attack(.physical(.pierce), for: .random([.d4]))),
                ActionCard(title: "Pierce", description: "Damage an adjacent enemy for 1d4", action: .attack(.physical(.pierce), for: .random([.d4]))),
            ])
        ) {
            self.head = head
            self.torso = torso
            self.feet = feet
            self.hands = hands
        }
    }
}


