//
//  Action.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

enum Action: Actionable {
    case attack(as: Attack, for: [MagnitudeComponent], from: [Range])
    case bolster(for: [MagnitudeComponent])
    case heal(for: [MagnitudeComponent])
    case buff(Buff)
    case debuff(Debuff)
    case movement(for: Int)
    case equip(to: Deck.GearSlot)

    func perform(by source: Pawn, on targets: [Pawn]? = [], using card: GearCard? = nil) {
        switch self {
            case let .attack(_, magnitudeComponents, _):
            
            print("magnitudeComponents", magnitudeComponents)
                
                let amt: Int = magnitudeComponents.reduce(0) {
                    switch $1 {
                    case let .constant(int): $0 + int
                    case let .roll(dice): $0 + dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                    }
                }
            
                print("amt", amt)

                targets?.forEach {
                    if $0.bolsteredBy > 0 {
                        if amt >= $0.bolsteredBy {
                            print("hp before", $0.hp)
                            print("bolsteredBy", $0.bolsteredBy)
                            $0.hp -= (amt - Int($0.bolsteredBy))
                            $0.bolsteredBy = 0
                            print("hp after", $0.hp)
                        } else {
                            print("bolsteredBy before", $0.bolsteredBy)
                            $0.bolsteredBy -= amt
                            print("bolsteredBy after", $0.bolsteredBy)
                        }
                    } else {
                        print("hp before", $0.hp)
                        $0.hp -= amt
                        print("hp after", $0.hp)
                    }
                }
            
            case let .bolster(magnitudeComponents):
                let amt: Int = magnitudeComponents.reduce(0) {
                    switch $1 {
                    case let .constant(int): $0 + int
                    case let .roll(dice): $0 + dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                    }
                }
                
                targets?.forEach { $0.bolsteredBy += amt }

            case let .equip(to):
                if card == nil { return }
                switch to {
                case .wearable(.head):
                    if source.deck.equipment.head != nil { source.deck.unequipGearCard(.wearable(.head)) }
                    source.deck.equipGearCard(card!)
                
                case .wearable(.torso):
                    if source.deck.equipment.torso != nil { source.deck.unequipGearCard(.wearable(.torso)) }
                    source.deck.equipGearCard(card!)
                
                case .wearable(.feet):
                    if source.deck.equipment.feet != nil { source.deck.unequipGearCard(.wearable(.feet)) }
                    source.deck.equipGearCard(card!)
                
                case .wearable(.hands):
                    if source.deck.equipment.hands != nil { source.deck.unequipGearCard(.wearable(.hands)) }
                    source.deck.equipGearCard(card!)
                
                case .armament(.mainhand):
                    if source.deck.equipment.mainhand != nil { source.deck.unequipGearCard(.armament(.mainhand)) }
                    source.deck.equipGearCard(card!)
                    
                case .armament(.offhand):
                    if source.deck.equipment.offhand != nil { source.deck.unequipGearCard(.armament(.mainhand)) }
                    source.deck.equipGearCard(card!)
                }
            default:
                return
        }
    }

    enum MagnitudeComponent {
        case constant(Int)
        case roll([Die])
    }

    // attack
    enum Attack {
        case physical(PhysicalAttack)
        case metaphysical(MetaphysicalAttack)
        
        enum PhysicalAttack {
            case slash
            case bludgeon
            case pierce
        }
        
        enum MetaphysicalAttack {
            case arcane
            case fire
            case cold
            case shock
            case poison
            case lux
            case dark
            // idk, i just started listing things
        }
    }
    
    enum Range {
        case melee
        case reach
        case ranged(Distance)
        
        enum Distance {
            case short
            case medium
            case long
            case infinite
        }
    }
    
    // buff
    enum Buff {}

    // debuff
    enum Debuff {}
}
