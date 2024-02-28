//
//  Gear.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/18/24.
//

import Foundation

struct Gear {
    let name: String
    let description: String
    let perks: [GearPerkEffect] = []
    
    let slot: Slot
    let weight: Weight
    let rarity: Rarity
    
    let primaryPassive: Passive?
    let uniquePassive: Passive?
    
    let primaryAction: (Action, CardQuantity)?
    let uniqueAction: (Action, CardQuantity)?
    
    private init(
        name: String? = "",
        description: String? = "",
        slot: Slot? = [.armament(.allCases.randomElement()!), .wearable(.allCases.randomElement()!)].randomElement()!,
        weight: Weight? = .allCases.randomElement()!,
        rarity: Rarity? = .roll(),
        primaryPassive: Passive? = nil,
        uniquePassive: Passive? = nil,
        primaryAction: (Action, CardQuantity)? = nil,
        uniqueAction: (Action, CardQuantity)? = nil
    ) {
        let perks = Gear.determineGearPerks(slot!, rarity!, weight!)
        
        self.name = name!
        self.description = description!
        self.slot = slot!
        self.weight = weight!
        self.rarity = rarity!
        
        self.primaryPassive = primaryPassive
        self.uniquePassive = uniquePassive
        
        self.primaryAction = primaryAction != nil ? perks.reduce(primaryAction!) { acc, cur in
            cur.apply(to: acc)
        } : nil
        self.uniqueAction = uniqueAction
    }
    
    init(
        slot: Slot? = [.armament(.allCases.randomElement()!), .wearable(.allCases.randomElement()!)].randomElement()!
    ) {
        let rarity: Rarity = .roll()
        let weight: Weight = .allCases.randomElement()!
        let perks = Gear.determineGearPerks(slot!, rarity, weight)
        let gear: Self? = switch slot {
        case let .armament(type): Gear.weapons.filter { weapon in weapon.slot == .armament(type) }.filter { weapon in weapon.weight == weight }.randomElement() ?? nil
        case let .wearable(type): Gear.armor.filter { armor in armor.slot == .wearable(type) }.filter { armor in armor.weight == weight }.randomElement() ?? nil
        default: nil
        }
        
        self.name = gear?.name ?? ""
        self.description = gear?.description ?? ""
        self.slot = slot!
        self.weight = weight
        self.rarity = rarity
        
        self.primaryPassive = gear?.primaryPassive
        self.uniquePassive = gear?.uniquePassive
        
        self.primaryAction = gear?.primaryAction != nil ? perks.reduce(gear!.primaryAction!) { acc, cur in
            cur.apply(to: acc)
        } : nil
        self.uniqueAction = gear?.uniqueAction
    }
    
    private static let weapons: [Self] = [
        
        Self(
            name: "Dagger",
            description: "Adds 2 1d4 melee attack cards.",
            slot: .armament(.mainhand),
            weight: Weight.none,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d4])], from: [.melee]), 2)
        ),
        
        Self(
            name: "Throwing Stars",
            description: "Adds 2 1d4 short range attack cards.",
            slot: .armament(.mainhand),
            weight: Weight.none,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d4])], from: [.ranged(.short)]), 2)
        ),
        
        
        Self(
            name: "Shortbow",
            description: "Adds 2 1d4 short range attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d4])], from: [.ranged(.short)]), 2)
        ),
        
        Self(
            name: "Handaxe",
            description: "Adds 4 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d6])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Spear",
            description: "Adds 4 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d6])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Flail",
            description: "Adds 4 1d8 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d8])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Rapier",
            description: "Adds 4 1d8 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d8])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Hand Crossbow",
            description: "Adds 4 1d6 short range attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d6])], from: [.ranged(.short)]), 4)
        ),
        
        Self(
            name: "Shortsword",
            description: "Adds 4 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d6])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Scimitar",
            description: "Adds 4 1d4 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d6])], from: [.melee]), 4)
        ),
        
        Self(
            name: "Whip",
            description: "Adds 4 1d4 melee attack cards with reach.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d4])], from: [.melee, .reach]), 4)
        ),
        
        Self(
            name: "Longbow",
            description: "Adds 4 1d8 long range attack cards.",
            slot: .armament(.mainhand),
            weight: .light,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d8])], from: [.ranged(.long)]), 4)
        ),
        
        // medium
        
        Self(
            name: "Mace",
            description: "Adds 6 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.bludgeon), for: [.roll([.d6])], from: [.melee]), 6)
        ),
        
        Self(
            name: "Crossbow",
            description: "Adds 6 1d8 medium range attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d8])], from: [.ranged(.medium)]), 6)
        ),
        
        Self(
            name: "Quarterstaff",
            description: "Adds 6 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.bludgeon), for: [.roll([.d6])], from: [.melee]), 6)
        ),
        
        Self(
            name: "Battleaxe",
            description: "Adds 6 1d8 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d8])], from: [.melee]), 6)
        ),
        
        Self(
            name: "Morningstar",
            description: "Adds 6 1d8 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d8])], from: [.melee]), 6)
        ),
        
        Self(
            name: "Longsword",
            description: "Adds 6 1d8 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d8])], from: [.melee]), 6)
        ),
        
        Self(
            name: "Trident",
            description: "Adds 6 1d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .medium,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d6])], from: [.melee]), 6)
        ),
        
        // heavy
        
        Self(
            name: "Greataxe",
            description: "Adds 8 1d12 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d12])], from: [.melee]), 8)
        ),
        
        Self(
            name: "Greatsword",
            description: "Adds 8 2d6 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d6, .d6])], from: [.melee]), 8)
        ),
        
        Self(
            name: "Glaive",
            description: "Adds 8 1d10 melee attack cards with reach.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d10])], from: [.melee, .reach]), 8)
        ),
        
        Self(
            name: "Halberd",
            description: "Adds 8 1d10 melee attack cards with reach.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d10])], from: [.melee, .reach]), 8)
        ),
        
        Self(
            name: "Lance",
            description: "Adds 8 1d12 melee attack cards with reach.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d12])], from: [.melee, .reach]), 8)
        ),
        
        Self(
            name: "Heavy Crossbow",
            description: "Adds 8 1d10 long range attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d10])], from: [.ranged(.long)]), 8)
        ),
        
        Self(
            name: "Greatbow",
            description: "Adds 8 2d6 long range attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d6, .d6])], from: [.ranged(.long)]), 8)
        ),
        
        Self(
            name: "Maul",
            description: "Adds 10 2d6 long range attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.bludgeon), for: [.roll([.d6, .d6])], from: [.melee]), 10)
        ),
        
        Self(
            name: "Pike",
            description: "Adds 10 1d10 melee attack cards with reach.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.pierce), for: [.roll([.d10])], from: [.melee, .reach]), 10)
        ),
    ]
    
    private static let armor: [Self] = [
        
        // clothing
        
        Self(
            name: "Hood",
            slot: .wearable(.head),
            weight: Weight.none
        ),
        
        Self(
            name: "Tunic",
            slot: .wearable(.torso),
            weight: Weight.none
        ),
        
        Self(
            name: "Handwraps",
            slot: .wearable(.hands),
            weight: Weight.none
        ),
        
        Self(
            name: "Shoes",
            description: "Adds 5 movement cards.",
            slot: .wearable(.feet),
            weight: Weight.none,
            primaryAction: (.movement(for: 1), 5)
        ),
        
        // light armor
        
        Self(
            name: "Light Helm",
            description: "Adds 1 1d2+1 bolster card.",
            slot: .wearable(.head),
            weight: .light,
            primaryAction: (.bolster(for: [.roll([.d2]), .constant(1)]), 1)
        ),
        
        Self(
            name: "Light Chest Armor",
            description: "Adds 2 1d2+1 bolster cards.",
            slot: .wearable(.torso),
            weight: .light,
            primaryAction: (.bolster(for: [.roll([.d2, .d2]), .constant(1)]), 1)
        ),
        
        Self(
            name: "Light Gloves",
            description: "Adds 1 1d2+1 bolster card.",
            slot: .wearable(.hands),
            weight: .light,
            primaryAction: (.bolster(for: [.roll([.d2]), .constant(1)]), 1)
        ),
        
        Self(
            name: "Light Boots",
            description: "Adds 3 movement cards.",
            slot: .wearable(.feet),
            weight: .light,
            primaryAction: (.movement(for: 1), 3)
        ),
        
        // medium armor
        
        Self(
            name: "Medium Helm",
            description: "Adds 2 1d4+2 bolster cards.",
            slot: .wearable(.head),
            weight: .medium,
            primaryAction: (.bolster(for: [.roll([.d4]), .constant(2)]), 2)
        ),
        
        Self(
            name: "Medium Chest Armor",
            description: "Adds 2 2d4+2 bolster cards.",
            slot: .wearable(.torso),
            weight: .medium,
            primaryAction: (.bolster(for: [.roll([.d4, .d4]), .constant(2)]), 2)
        ),
        
        Self(
            name: "Medium Gloves",
            description: "Adds 2 1d4+2 bolster cards.",
            slot: .wearable(.hands),
            weight: .medium,
            primaryAction: (.bolster(for: [.roll([.d4]), .constant(2)]), 2)
        ),
        
        Self(
            name: "Medium Boots",
            description: "Adds 2 movement cards.",
            slot: .wearable(.feet),
            weight: .medium,
            primaryAction: (.movement(for: 1), 2)
        ),
        
        // heavy armor
        
        Self(
            name: "Heavy Helm",
            description: "Adds 3 1d6+3 bolster cards.",
            slot: .wearable(.head),
            weight: .heavy,
            primaryAction: (.bolster(for: [.roll([.d6]), .constant(3)]), 3)
        ),
        
        Self(
            name: "Heavy Chest Armor",
            description: "Adds 3 2d6+3 bolster cards.",
            slot: .wearable(.torso),
            weight: .heavy,
            primaryAction: (.bolster(for: [.roll([.d6, .d6]), .constant(3)]), 3)
        ),
        
        Self(
            name: "Heavy Gloves",
            description: "Adds 3 1d6+3 bolster cards.",
            slot: .wearable(.hands),
            weight: .heavy,
            primaryAction: (.bolster(for: [.roll([.d6]), .constant(3)]), 3)
        ),
        
        Self(
            name: "Heavy Boots",
            description: "Adds 1 movement card.",
            slot: .wearable(.feet),
            weight: .heavy,
            primaryAction: (.movement(for: 1), 1)
        )
    ]
    
    private static func determineGearPerks(_ slot: Slot, _ rarity: Rarity, _ weight: Weight) -> [GearPerkEffect] {
        // general rules:
        // common: 0-1 perks, uncommon: 1-2, rare: 2-3, veryrare: 3-4, legendary: 4-5, mythical: always 6
        // lower bound should be more common than upper bound
        // at least one perk's rarity should be equal to the gear rarity
        // the rest can be equal to or less than the gear rarity
        // the exception is mythical gear: always rolls 6 perks, and all perks that aren't mythical are legendary
        
        let rarities: [Rarity] = switch rarity {
        case .mythical: [.mythical, .legendary, .veryrare, .rare, .uncommon, .common]
        case .legendary: [.legendary, .veryrare, .rare, .uncommon, .common]
        case .veryrare: [.veryrare, .rare, .uncommon, .common]
        case .rare: [.rare, .uncommon, .common]
        case .uncommon: [.uncommon, .common]
        case .common: [.common]
        }
        
        let perkCount: Int = switch rarity {
        case .mythical: 6
        case .legendary: Die.d12.roll()[0] > 8 ? 5 : 4
        case .veryrare: Die.d12.roll()[0] > 8 ? 4 : 3
        case .rare: Die.d12.roll()[0] > 8 ? 3 : 2
        case .uncommon: Die.d12.roll()[0] > 8 ? 2 : 1
        case .common: Die.d12.roll()[0] > 8 ? 1 : 0
        }
        
        var perks: [GearPerkEffect] = []
        let possiblePerks = Gear.perks
            .filter { perk in rarities.contains(perk.1.0)}
        

        
        if perkCount > 0 {
            for n in 1...perkCount {
                if n == 1 {
                    //  get a perk equal to the gear rarity
                    if let perk = possiblePerks.filter({ perk in perk.1.0 == rarity }).randomElement() {
                        perks.append(perk.0)
                    }
                } else {
                    // get a perk equal to or less than the gear rarity
                    if let perk = possiblePerks.randomElement() {
                        perks.append(perk.0)
                    }
                }
            }
        }
        
        print(perkCount, perks)
        
        return perks
    }
    
    private static let perks: [(GearPerkEffect, Reqs)] = [
        
        (.alterMagnitude(by: 1), (.common, nil, nil)),
        (.alterMagnitude(by: 2), (.common, nil, nil)),
        (.alterMagnitude(by: 3), (.uncommon, nil, nil)),
        (.alterMagnitude(by: 4), (.uncommon, nil, nil)),
        (.alterMagnitude(by: 5), (.uncommon, nil, nil)),
        (.alterMagnitude(by: 6), (.rare, nil, nil)),
        (.alterMagnitude(by: 7), (.rare, nil, nil)),
        (.alterMagnitude(by: 8), (.rare, nil, nil)),
        (.alterMagnitude(by: 9), (.veryrare, nil, nil)),
        (.alterMagnitude(by: 10), (.veryrare, nil, nil)),
        (.alterMagnitude(by: 11), (.veryrare, nil, nil)),
        (.alterMagnitude(by: 12), (.legendary, nil, nil)),
        (.alterMagnitude(by: 13), (.legendary, nil, nil)),
        (.alterMagnitude(by: 14), (.legendary, nil, nil)),
        (.alterMagnitude(by: 15), (.legendary, nil, nil)),
        (.alterMagnitude(by: 150), (.mythical, nil, nil)),
        
        (.alterCardQuantity(by: 1), (.rare, nil, nil)),
        (.alterCardQuantity(by: -1), (.rare, nil, nil)),
        (.alterCardQuantity(by: 2), (.veryrare, nil, nil)),
        (.alterCardQuantity(by: -2), (.veryrare, nil, nil)),
        (.alterCardQuantity(by: 3), (.legendary, nil, nil)),
        (.alterCardQuantity(by: -3), (.legendary, nil, nil)),
    ]
}

enum Slot: Equatable {
    case armament(ArmamentSlot)
    case wearable(WearableSlot)
    
    enum ArmamentSlot: String, CaseIterable {
        case mainhand
        case offhand
    }
    
    enum WearableSlot: String, CaseIterable {
        case head
        case torso
        case hands
        case feet
    }
}

enum Weight: Int, CaseIterable {
    case none
    case light
    case medium
    case heavy
}

typealias Reqs = (Rarity, [Slot]?, [Weight]?)

enum ResourceEffectMagnitude {
    case roll(Die)
    case constant(Int)
}

typealias CardQuantity = Int

enum Passive {
    case defense
}
