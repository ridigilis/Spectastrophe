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
    
    let title: String
    let description: String
    let rarity: Rarity?
    let primaryAction: Action?

    let gear: Gear
    let cards: [ActionCard]

    init(gear: Gear) {
        let id = UUID()
        self.id = id
        self.gear = gear
        self.title = gear.name
        self.description = gear.description
        self.rarity = gear.rarity
        self.primaryAction = .equip(to: gear.slot)
        
        var cards: [ActionCard] = []
        if gear.primaryAction != nil {
            for _ in 1..<gear.primaryAction!.1 {
                let title: String = switch gear.primaryAction!.0 {
                case.attack: "Attack"
                case.bolster: "Bolster"
                case.movement: "Move"
                default: ""
                }
                
                let description: String = switch gear.primaryAction!.0 {
                case .attack: "Attack"
                case .bolster: "Bolster"
                case .movement: "Move"
                default: ""
                }
                
                let range: [Action.Range]? = switch gear.primaryAction!.0 {
                case let .attack(_,_,range): range
                default: nil
                }
                
                
                cards += [
                    ActionCard(
                        parentId: id,
                        
                        title: title,
                        description: description,
                        
                        primaryAction: gear.primaryAction!.0,
                        range: range
                    )
                ]
            }
        }
        self.cards = cards
    }
}
