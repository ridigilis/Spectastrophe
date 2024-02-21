//
//  LootMachine.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/10/24.
//

//import Foundation
//
//struct LootMachine {
//    func gimme(
//        slot specifiedSlot: Deck.GearSlot? = nil,
//        rarity specifiedRarity: Rarity? = nil,
//        rarityModifier: Int = 0,
//        weight specifiedWeight: Weight? = nil
//    ) -> GearCard {
//        let slot: Deck.GearSlot = specifiedSlot ?? rollSlot()
//        let rarity: Rarity = specifiedRarity ?? rollRarity()
//        let weight: Weight = specifiedWeight ?? rollWeight()
//        
//        switch slot {
//        case .head, .torso, .hands, .feet:
//            let gear = self.armor.filter({ $0.value.0 == weight && $0.value.4 == slot }).randomElement()
//            var cards: [ActionCard] = []
//            if weight != .none {
//                for _ in 0...gear!.value.3 {
//                    cards.append(
//                        ActionCard(
//                            title: "Bolster",
//                            description: "Offset damage taken on your next turn by  \(gear!.value.1.count)\(gear!.value.1[0])",
//                            action: .bolster(for: [.roll(gear!.value.1), .constant(gear!.value.addedToRoll)])
//                        )
//                    )
//                }
//            }
//            
//            return GearCard(
//                slot: slot,
//                rarity: rarity,
//                weight: weight,
//                title: gear!.key,
//                description: weight == .none 
//                    ? "Provides very minimal protection"
//                    : "Adds \(gear!.value.3) bolster cards to your deck that each offset damage by \(gear!.value.1.count)\(gear!.value.1[0])",
//                cards: cards
//            )
//            
//        case .mainhand, .offhand:
//            let gear = self.weapons.filter({ $0.value.0 == weight }).randomElement()
//            var cards: [ActionCard] = []
//            for _ in 0...gear!.value.4 {
//                cards.append(
//                    ActionCard(
//                        title: "Attack",
//                        description: "Deal \(gear!.value.3.count)\(gear!.value.3[0])",
//                        action: .attack(as: gear!.value.1[0], for: [.roll(gear!.value.3)], from: gear!.value.2),
//                        range: gear!.value.2
//                    )
//                )
//            }
//            
//            return GearCard(
//                slot: slot,
//                rarity: rarity,
//                weight: weight,
//                title: gear!.key,
//                description: "Adds \(gear!.value.4) attacks to your deck that each deal \(gear!.value.3.count)\(gear!.value.3[0]).",
//                cards: cards
//            )
//        }
//    }
//    
//    func rollSlot() -> Deck.GearSlot {
//        let slots: [Deck.GearSlot] = [.head, .torso, .feet, .hands, .mainhand, .offhand]
//        return slots.randomElement()!
//    }
//    
//    func rollRarity(with modifier: Int = 0) -> Rarity {
//        let roll = Die.d20.sumRoll(6) + modifier
//        
//        if roll > 110 { return .mythical }
//        if roll > 100 { return .legendary }
//        if roll > 90 { return .veryrare }
//        if roll > 80 { return .rare }
//        if roll > 70 { return .uncommon}
//        
//        return .common
//    }
//    
//    func rollWeight() -> Weight {
//        let weights: [Weight] = [.none, .light, .medium, .heavy]
//        return weights.randomElement()!
//    }
//    
//    typealias ArmorTable = [String: (Weight, [Die], addedToRoll: Int, actionQuantity: Int, Deck.GearSlot)]
//    
//    let armor: ArmorTable = [
//        "Hood": (.none, [], 0, 0, .head),
//        "Tunic": (.none, [], 0, 0, .torso),
//        "Handwraps": (.none, [], 0, 0, .hands),
//        "Shoes": (.none, [], 0, 0, .feet),
//        
//        "Light Helm": (.light, [.d2], 1, 1, .head),
//        "Light Chest Armor": (.light, [.d2, .d2], 1, 1, .torso),
//        "Light Gloves": (.light, [.d2], 1, 1, .hands),
//        "Light Boots": (.light, [.d2], 1, 1, .feet),
//        
//        "Medium Helm": (.medium, [.d4], 2, 2, .head),
//        "Medium Chest Armor": (.medium, [.d4, .d4], 2, 2, .torso),
//        "Medium Gloves": (.medium, [.d4], 2, 2, .hands),
//        "Medium Boots": (.medium, [.d4], 2, 2, .feet),
//        
//        "Heavy Helm": (.heavy, [.d6], 3, 3, .head),
//        "Heavy Chest Armor": (.heavy, [.d6, .d6], 3, 3, .torso),
//        "Heavy Gloves": (.heavy, [.d6], 3, 3, .hands),
//        "Heavy Boots": (.heavy, [.d6], 3, 3, .feet),
//    ]
//    
//    typealias WeaponTable = [String: (Weight, [Action.Attack], [Action.Range], [Die], actionQuantity: Int)]
//    
//    let weapons: WeaponTable = [
//        "Dagger": (.none, [.physical(.pierce)], [.melee], [.d4], 2),
//        "Throwing Stars": (.none, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
//        
//        "Shortbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
//        "Handaxe": (.light, [.physical(.slash)], [.melee], [.d6], 4),
//        "Spear": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
//        "Flail": (.light, [.physical(.bludgeon)], [.melee], [.d8], 4),
//        "Rapier": (.light, [.physical(.pierce)], [.melee], [.d8], 4),
//        "Hand Crossbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d6], 4),
//        "Shortsword": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
//        "Scimitar": (.light, [.physical(.slash)], [.melee], [.d6], 4),
//        "Whip": (.light, [.physical(.slash)], [.melee, .reach], [.d4], 4),
//        "Longbow": (.light, [.physical(.pierce)], [.ranged(.long)], [.d8], 4),
//        
//        "Mace": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
//        "Crossbow": (.medium, [.physical(.pierce)], [.ranged(.medium)], [.d8], 6),
//        "Quarterstaff": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
//        "Battleaxe": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
//        "Morningstar": (.medium, [.physical(.pierce)], [.melee], [.d8], 6),
//        "Longsword": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
//        "Trident": (.medium, [.physical(.pierce)], [.melee], [.d6], 6),
//        
//        "Greataxe": (.heavy, [.physical(.slash)], [.melee], [.d12], 8),
//        "Greatsword": (.heavy, [.physical(.slash)], [.melee], [.d6, .d6], 8),
//        "Glaive": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
//        "Halberd": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
//        "Lance": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d12], 8),
//        "Heavy Crossbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d10], 8),
//        "Greatbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d6, .d6], 8),
//        "Pike": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d10], 10),
//        "Maul": (.heavy, [.physical(.bludgeon)], [.melee], [.d6, .d6], 10),
//    ]
//}
