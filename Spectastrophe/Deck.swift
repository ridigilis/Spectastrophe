//
//  Deck.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

final class Deck: ObservableObject {
    @Published var drawPile: [Card]
    @Published var hand: [Card]
    @Published var playArea: [Card]
    @Published var discardPile: [Card]
    @Published var exhaustPile: [Card]

    init(drawPile: [Card] = [],
         hand: [Card] = [],
         playArea: [Card] = [],
         discardPile: [Card] = [],
         exhaustPile: [Card] = []
    ) {
        self.drawPile = drawPile
        self.hand = hand
        self.playArea = playArea
        self.discardPile = discardPile
        self.exhaustPile = exhaustPile
    }

    private func drawCardFromTop() {
        let card = self.drawPile.first

        self.drawPile = self.drawPile.filter { $0 != card }
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

    func playFromHand(_ card: Card) {
        self.hand = self.hand.filter { $0 != card }
        self.playArea = self.playArea + [card].compactMap { $0 }
    }

    func discardFromHand(_ card: Card) {
        self.hand = self.hand.filter { $0 != card }
        self.discardPile = self.discardPile + [card].compactMap{ $0 }
    }

    func exhaust(_ card: Card) {
        self.playArea = self.playArea.filter { $0 != card }
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
}
