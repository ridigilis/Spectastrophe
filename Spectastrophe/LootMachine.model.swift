//
//  LootMachine.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/10/24.
//

import Foundation

struct LootMachine {
    func gimme(
        rarity specifiedRarity: Rarity? = nil,
        rarityModifier: UInt = 0,
        weight specifiedWeight: Weight? = nil
    ) -> GearCard {
        let rarity: Rarity = specifiedRarity ?? rollRarity()
        let weight: Weight = specifiedWeight ?? rollWeight()
        let gear = self.weapons.randomElement()
        
        var cards: [ActionCard] = []
        for _ in 0...gear!.value.4 {
            cards.append(ActionCard(rarity: .none, title: "Attack", description: "Deal \(gear!.value.3.count)\(gear!.value.3[0])", action: .attack(gear!.value.1[0], for: .random(gear!.value.3), from: gear!.value.2), range: gear!.value.2))
        }
        
        return GearCard(
            slot: .hands,
            rarity: rarity,
            weight: weight,
            title: gear!.key,
            description: "Adds \(gear!.value.4) attacks to your deck that each deal \(gear!.value.3.count)\(gear!.value.3[0])",
            cards: cards
        )
    }
    
    func rollRarity(with modifier: UInt = 0) -> Rarity {
        let roll = Die.d20.sumRoll(6) + modifier
        
        if roll > 110 { return .mythical }
        if roll > 100 { return .legendary }
        if roll > 90 { return .veryrare }
        if roll > 80 { return .rare }
        if roll > 70 { return .uncommon}
        
        return .common
    }
    
    func rollWeight() -> Weight {
        let weights: [Weight] = [.light, .medium, .heavy]
        return weights.randomElement()!
    }
    
    let weapons: [String: (Weight, [Action.Attack], [Action.Range], [Die], actionQuantity: UInt)] = [
        "Dagger": (.light, [.physical(.pierce)], [.melee], [.d4], 2),
        "Throwing Stars": (.light, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
        "Shortbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
        "Handaxe": (.light, [.physical(.slash)], [.melee], [.d6], 4),
        "Spear": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
        "Flail": (.light, [.physical(.bludgeon)], [.melee], [.d8], 4),
        "Rapier": (.light, [.physical(.pierce)], [.melee], [.d8], 4),
        "Hand Crossbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d6], 4),
        "Shortsword": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
        "Scimitar": (.light, [.physical(.slash)], [.melee], [.d6], 4),
        "Whip": (.light, [.physical(.slash)], [.melee, .reach], [.d4], 4),
        "Longbow": (.light, [.physical(.pierce)], [.ranged(.long)], [.d8], 4),
        
        "Mace": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
        "Crossbow": (.medium, [.physical(.pierce)], [.ranged(.medium)], [.d8], 6),
        "Quarterstaff": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
        "Battleaxe": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
        "Morningstar": (.medium, [.physical(.pierce)], [.melee], [.d8], 6),
        "Longsword": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
        "Trident": (.medium, [.physical(.pierce)], [.melee], [.d6], 6),
        
        "Greataxe": (.heavy, [.physical(.slash)], [.melee], [.d12], 8),
        "Greatsword": (.heavy, [.physical(.slash)], [.melee], [.d6, .d6], 8),
        "Glaive": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
        "Halberd": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
        "Lance": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d12], 8),
        "Heavy Crossbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d10], 8),
        "Greatbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d6, .d6], 8),
        "Pike": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d10], 10),
        "Maul": (.heavy, [.physical(.bludgeon)], [.melee], [.d6, .d6], 10),
    ]
}
