//
//  Action.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

enum Action: Actionable {
    case attack(Attack, for: Quantity, from: [Range])
    case bolster(for: Quantity)
    case heal(for: Quantity)
    case buff(Buff)
    case debuff(Debuff)
    case movement(for: Quantity?)
    case equip(to: Deck.GearSlot)

    func perform(by source: Pawn, on targets: [Pawn]? = [], using card: GearCard? = nil) {
        switch self {
            case let .attack(_, quantity, _):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                case let .randomAndConstant(dice, num): dice.map { $0.roll().reduce(0, +) }.reduce(0, +) + num
                }

                targets?.forEach {
                    if $0.bolsteredBy > 0 {
                        if amt >= $0.bolsteredBy {
                            $0.hp -= (Int(amt) - Int($0.bolsteredBy))
                            $0.bolsteredBy = 0
                        } else {
                            $0.bolsteredBy -= amt
                        }
                    } else {
                        $0.hp -= Int(amt)
                    }
                }
            
            case let .bolster(quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                case let .randomAndConstant(dice, num): dice.map { $0.roll().reduce(0, +) }.reduce(0, +) + num
                }
                
                targets?.forEach { $0.bolsteredBy += amt }

            case let .movement(quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                case let .randomAndConstant(dice, num): dice.map { $0.roll().reduce(0, +) }.reduce(0, +) + num
                case .none: UInt(1)
                }

            case let .equip(to):
                if card == nil { return }
                switch to {
                case .head:
                    if source.deck.equipment.head != nil { source.deck.unequipGearCard(.head) }
                    source.deck.equipGearCard(card!)
                
                case .torso:
                    if source.deck.equipment.torso != nil { source.deck.unequipGearCard(.torso) }
                    source.deck.equipGearCard(card!)
                
                case .feet:
                    if source.deck.equipment.feet != nil { source.deck.unequipGearCard(.feet) }
                    source.deck.equipGearCard(card!)
                
                case .hands:
                    if source.deck.equipment.hands != nil { source.deck.unequipGearCard(.hands) }
                    source.deck.equipGearCard(card!)
                
                case .mainhand:
                    if source.deck.equipment.mainhand != nil { source.deck.unequipGearCard(.mainhand) }
                    source.deck.equipGearCard(card!)
                    
                case .offhand:
                    if source.deck.equipment.offhand != nil { source.deck.unequipGearCard(.offhand) }
                    source.deck.equipGearCard(card!)
                }
            default:
                return
        }
    }

    enum Quantity {
        case constant(UInt)
        case random([Die])
        case randomAndConstant([Die], UInt)
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
