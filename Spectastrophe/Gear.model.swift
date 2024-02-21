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
    
    let primaryAction: (Action, CardQuantity)?
    
    private init(
        name: String? = "",
        description: String? = "",
        slot: Slot? = [.armament(.allCases.randomElement()!), .wearable(.allCases.randomElement()!)].randomElement()!,
        weight: Weight? = .allCases.randomElement()!,
        rarity: Rarity? = .roll(),
        primaryAction: (Action, CardQuantity)? = nil
    ) {
        let perks = Gear.determineGearPerks(slot!, rarity!, weight!)
        
        self.name = name!
        self.description = description!
        self.slot = slot!
        self.weight = weight!
        self.rarity = rarity!
        self.primaryAction = primaryAction != nil ? perks.reduce(primaryAction!) { acc, cur in
            cur.apply(to: acc)
        } : nil
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
        self.primaryAction = gear?.primaryAction != nil ? perks.reduce(gear!.primaryAction!) { acc, cur in
            cur.apply(to: acc)
        } : nil
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
        
        ////    "Crossbow": (.medium, [.physical(.pierce)], [.ranged(.medium)], [.d8], 6),
        ////    "Quarterstaff": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
        ////    "Battleaxe": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
        ////    "Morningstar": (.medium, [.physical(.pierce)], [.melee], [.d8], 6),
        ////    "Longsword": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
        ////    "Trident": (.medium, [.physical(.pierce)], [.melee], [.d6], 6),
        
        // heavy
        
        Self(
            name: "Greataxe",
            description: "Adds 8 1d12 melee attack cards.",
            slot: .armament(.mainhand),
            weight: .heavy,
            primaryAction: (.attack(as: .physical(.slash), for: [.roll([.d12])], from: [.melee]), 8)
        ),
        
        ////    "Greatsword": (.heavy, [.physical(.slash)], [.melee], [.d6, .d6], 8),
        ////    "Glaive": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
        ////    "Halberd": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
        ////    "Lance": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d12], 8),
        ////    "Heavy Crossbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d10], 8),
        ////    "Greatbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d6, .d6], 8),
        ////    "Pike": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d10], 10),
        ////    "Maul": (.heavy, [.physical(.bludgeon)], [.melee], [.d6, .d6], 10),

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
            slot: .wearable(.feet),
            weight: Weight.none
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
            description: "Adds 1 1d2+1 bolster card.",
            slot: .wearable(.feet),
            weight: .light,
            primaryAction: (.bolster(for: [.roll([.d2]), .constant(1)]), 1)
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
            description: "Adds 2 1d4+2 bolster cards.",
            slot: .wearable(.feet),
            weight: .medium,
            primaryAction: (.bolster(for: [.roll([.d4]), .constant(2)]), 2)
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
            description: "Adds 3 1d6+3 bolster cards.",
            slot: .wearable(.feet),
            weight: .heavy,
            primaryAction: (.bolster(for: [.roll([.d6]), .constant(3)]), 3)
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
        
//        (.alterSpread(by: (min: -1, max: 1)), (.rare, nil, nil)),
//        (.alterSpread(by: (min: 1, max: -1)), (.rare, nil, nil)),
//        (.alterSpread(by: (min: -2, max: 2)), (.veryrare, nil, nil)),
//        (.alterSpread(by: (min: 2, max: -2)), (.veryrare, nil, nil)),
//        (.alterSpread(by: (min: -3, max: 3)), (.legendary, nil, nil)),
//        (.alterSpread(by: (min: 3, max: -3)), (.legendary, nil, nil)),
//        
//        (.alterSpread(by: (min: 0, max: 1)), (.uncommon, nil, nil)),
//        (.alterSpread(by: (min: 1, max: 0)), (.uncommon, nil, nil)),
//        (.alterSpread(by: (min: 0, max: 2)), (.rare, nil, nil)),
//        (.alterSpread(by: (min: 2, max: 0)), (.rare, nil, nil)),
//        (.alterSpread(by: (min: 0, max: 3)), (.veryrare, nil, nil)),
//        (.alterSpread(by: (min: 3, max: 0)), (.veryrare, nil, nil)),
//        (.alterSpread(by: (min: 0, max: 4)), (.legendary, nil, nil)),
//        (.alterSpread(by: (min: 4, max: 0)), (.legendary, nil, nil)),
        
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

//enum Gear {
//    case armament(Armament)
//    case wearable(Wearable)
////    case adornment(Adornment)
////    case utility(Utility)
//}
//
//extension Gear {
//    struct Armament {
//        let slot: Slot = .allCases.randomElement()!
//        let weight: Weight = .allCases.randomElement()!
//        let rarity: Rarity = .roll()
//        let kind: Kind
//    }
//}
//
//extension Gear {
//    enum Weight: Int, CaseIterable {
//        case none = 0
//        case light
//        case medium
//        case heavy
//    }
//}
//
//extension Gear.Armament {
//    struct Weapon {
//        let name: String
//        let strike: Strike?
//    }
//}
//
//extension Gear.Armament.Weapon {
//    struct Strike {
//        let attack: Attack
//        let quantity: Int
//    }
//}
//
//extension Gear.Armament.Weapon {
//    init(
//        slot: Gear.Armament.Slot = .allCases.randomElement()!,
//        weight: Gear.Weight = .allCases.randomElement()!,
//        range: Range = [.melee(reach: false), .melee(reach: true), .ranged(.short), .ranged(.mid), .ranged(.long)].randomElement()!
//    ) {
//        let weapon = table
//            .filter {
//                $0.value.0.contains { slot } &&
//                $0.value.1 == weight &&
//                $0.value.2.contains { range }
//            }
//    }
//    
//    private static let table: [String: (slots: [Gear.Armament.Slot], weight: Gear.Weight, range: Range, damage: Damage, Int)] = [
//            "Dagger":(
//                slots: [.mainhand, .offhand],
//                weight: .none,
//                range: .melee(reach: false),
//                damage: Damage.physical(.pierce([.d4])),
//                2
//            ),
////    "Throwing Stars": (.none, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
////    
////    "Shortbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d4], 2),
////    "Handaxe": (.light, [.physical(.slash)], [.melee], [.d6], 4),
////    "Spear": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
////    "Flail": (.light, [.physical(.bludgeon)], [.melee], [.d8], 4),
////    "Rapier": (.light, [.physical(.pierce)], [.melee], [.d8], 4),
////    "Hand Crossbow": (.light, [.physical(.pierce)], [.ranged(.short)], [.d6], 4),
////    "Shortsword": (.light, [.physical(.pierce)], [.melee], [.d6], 4),
////    "Scimitar": (.light, [.physical(.slash)], [.melee], [.d6], 4),
////    "Whip": (.light, [.physical(.slash)], [.melee, .reach], [.d4], 4),
////    "Longbow": (.light, [.physical(.pierce)], [.ranged(.long)], [.d8], 4),
////    
////    "Mace": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
////    "Crossbow": (.medium, [.physical(.pierce)], [.ranged(.medium)], [.d8], 6),
////    "Quarterstaff": (.medium, [.physical(.bludgeon)], [.melee], [.d6], 6),
////    "Battleaxe": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
////    "Morningstar": (.medium, [.physical(.pierce)], [.melee], [.d8], 6),
////    "Longsword": (.medium, [.physical(.slash)], [.melee], [.d8], 6),
////    "Trident": (.medium, [.physical(.pierce)], [.melee], [.d6], 6),
////    
////    "Greataxe": (.heavy, [.physical(.slash)], [.melee], [.d12], 8),
////    "Greatsword": (.heavy, [.physical(.slash)], [.melee], [.d6, .d6], 8),
////    "Glaive": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
////    "Halberd": (.heavy, [.physical(.slash)], [.melee, .reach], [.d10], 8),
////    "Lance": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d12], 8),
////    "Heavy Crossbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d10], 8),
////    "Greatbow": (.heavy, [.physical(.pierce)], [.ranged(.long)], [.d6, .d6], 8),
////    "Pike": (.heavy, [.physical(.pierce)], [.melee, .reach], [.d10], 10),
////    "Maul": (.heavy, [.physical(.bludgeon)], [.melee], [.d6, .d6], 10),
//    ]
//}
//
//extension Gear.Armament.Weapon {
//    enum Range {
//        case melee(reach: Bool)
//        case ranged(Ranged)
//    }
//}
//
//extension Gear.Armament.Weapon.Range {
//    enum Ranged: CaseIterable {
//        case short
//        case mid
//        case long
//    }
//}
//extension Gear.Armament.Weapon {
//    struct Attack {
//        let damage: Damage
//    }
//}
//
//extension Gear.Armament.Weapon {
//    enum Damage {
//        case physical(Style)
//        case elemental(Element)
//    }
//}
//
//extension Gear.Armament.Weapon.Damage {
//    enum Style {
//        case pierce([ResourceEffectMagnitude])
//        case slash([ResourceEffectMagnitude])
//        case bludgeon([ResourceEffectMagnitude])
//    }
//}
//
//extension Gear.Armament.Weapon.Damage {
//    enum Element {
//        
//    }
//}
//
//extension Gear.Armament.Weapon {
//    struct Perk {
//
//    }
//}
//
//extension Gear.Armament {
//    enum Slot: CaseIterable {
//        case mainhand
//        case offhand
//        case twohand
//    }
//}
//
//extension Gear.Armament {
//    enum Kind {
//        case weapon(Weapon)
//        case shield
//    }
//}
//
//extension Gear.Armament {
//    init() {
//        self.kind = switch self.slot {
//        case .offhand: [Kind.weapon(Weapon(slot: self.slot)), Kind.shield].randomElement()!
//        default: Kind.weapon(Weapon(slot: self.slot))
//        }
//    }
//}
//
//extension Gear {
//    struct Wearable {
//        let slot: Slot = .allCases.randomElement()!
//        let weight: Weight = .allCases.randomElement()!
//        let rarity: Rarity = .roll()
//    }
//}
//
//extension Gear.Wearable {
//    enum Slot: CaseIterable {
//        case head
//        case torso
//        case hands
//        case feet
//    }
//}
//
enum ResourceEffectMagnitude {
    case roll(Die)
    case constant(Int)
}

typealias CardQuantity = Int
