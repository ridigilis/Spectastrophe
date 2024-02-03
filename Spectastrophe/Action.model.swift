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
                let equipment = source.deck.equipment
                switch to {
                    case .head:
                            // TODO: unequip -> move existing gear card to discard pile and remove all child cards from deck
                            equipment.head = card
                    case .torso:
                            // TODO: unequip -> move existing gear card to discard pile and remove all child cards from deck
                            equipment.torso = card
                    case .feet:
                            // TODO: unequip -> move existing gear card to discard pile and remove all child cards from deck
                            equipment.feet = card
                    case .hands:
                            // TODO: unequip -> move existing gear card to discard pile and remove all child cards from deck
                            equipment.hands = card
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