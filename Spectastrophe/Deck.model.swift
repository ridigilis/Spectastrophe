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
        let cardsFromMainHandSlot = equipment.mainhand?.cards ?? []
        let cardsFromOffHandSlot = equipment.offhand?.cards ?? []

        let initialDrawPile = drawPile + cardsFromHeadSlot + cardsFromTorsoSlot + cardsFromFeetSlot + cardsFromHandsSlot + cardsFromMainHandSlot + cardsFromOffHandSlot

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
        
        if card is GearCard { return }
        
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
    
    func equipGearCard(_ card: GearCard) {
        self.discardPile = self.discardPile + card.cards
        self.playArea = self.playArea.filter { $0.id != card.id }
        
        switch card.slot {
        case .head: self.equipment.head = card
        case .torso: self.equipment.torso = card
        case .hands: self.equipment.hands = card
        case .feet: self.equipment.feet = card
        case .mainhand: self.equipment.mainhand = card
        case .offhand: self.equipment.offhand = card
        }
    }
    
    func unequipGearCard(_ slot: GearSlot) {
        let card: GearCard? = switch slot {
        case .head: self.equipment.head
        case .torso: self.equipment.torso
        case .hands: self.equipment.hands
        case .feet: self.equipment.feet
        case .mainhand: self.equipment.mainhand
        case .offhand: self.equipment.offhand
        }
        
        self.drawPile = self.drawPile.filter { $0.parentId != card?.id }
        self.hand = self.hand.filter { $0.parentId != card?.id }
        self.playArea = self.playArea.filter { $0.parentId != card?.id }
        self.discardPile = self.discardPile.filter { $0.parentId != card?.id }
        self.exhaustPile = self.exhaustPile.filter { $0.parentId != card?.id }
        
        self.discardPile = self.discardPile + [card ?? nil].compactMap { $0 }
    }

    enum GearSlot: String {
        case head
        case torso
        case feet
        case hands
        case mainhand
        case offhand
    }

    final class Equipment: ObservableObject {
        @Published var head: GearCard?
        @Published var torso: GearCard?
        @Published var feet: GearCard?
        @Published var hands: GearCard?
        @Published var mainhand: GearCard?
        @Published var offhand: GearCard?

        init(
            head: GearCard? = nil,
            torso: GearCard? = nil,
            feet: GearCard? = nil,
            hands: GearCard? = nil,
            mainhand: GearCard? = LootMachine().gimme(slot: .mainhand),
            offhand: GearCard? = nil
        ) {
            self.head = head
            self.torso = torso
            self.feet = feet
            self.hands = hands
            self.mainhand = mainhand
            self.offhand = offhand
        }
    }
}
