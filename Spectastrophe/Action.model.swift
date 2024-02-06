//
//  Action.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

enum Action: Actionable {
    case attack(Attack, for: Quantity)
    case bolster(for: Quantity)
    case heal(for: Quantity)
    case buff(Buff)
    case debuff(Debuff)
    case movement(for: Quantity?)
    case equip(to: Deck.GearSlot)

    func perform(by source: Pawn, on targets: [Pawn]? = [], using card: GearCard? = nil) {
        switch self {
            case let .attack(_, quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                }

                targets?.forEach { $0.hp -= Int(amt) }

            case let .movement(quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                case .none: UInt(1)
                }

            case let .equip(to):
                if card == nil { return }
                switch to {
                    case .head:
                    source.deck.unequipGearCard(.head)
                    source.deck.equipGearCard(card!)
                    
                    case .torso:
                    source.deck.unequipGearCard(.torso)
                    source.deck.equipGearCard(card!)
                    
                    case .feet:
                    source.deck.unequipGearCard(.feet)
                    source.deck.equipGearCard(card!)
                    
                    case .hands:
                    source.deck.unequipGearCard(.hands)
                    source.deck.equipGearCard(card!)
                }
            default:
                return
        }
    }

    enum Quantity {
        case constant(UInt)
        case random([Die])
    }

    // attack
    enum Attack {
        case physical(PhysicalAttack)
        case metaphysical(MetaphysicalAttack)
    }

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
    // buff
    enum Buff {}

    // debuff
    enum Debuff {}
}
