//
//  GearPerk.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/17/24.
//

import Foundation

enum GearPerkEffect {
    case alterMagnitude(by: Int)
    case alterSpread(by: (min: Int, max: Int))
    case alterCardQuantity(by: Int)
    case perform(Action)
    case performUniqueAction
    
    func apply(to: (action: Action, cardQuantity: CardQuantity)) -> (Action, CardQuantity) {
        switch to.action {
            
        case let .attack(attack, components, ranges):
            switch self {
            case let .alterMagnitude(int): (.attack(as: attack, for: components + [.constant(int)], from: ranges), to.cardQuantity)
            case let .alterCardQuantity(int): (.attack(as: attack, for: components, from: ranges), (to.cardQuantity + int) < 1 ? 1 : (to.cardQuantity + int))
            default: to
            }
            
        case let .bolster(components):
            switch self {
            case let .alterMagnitude(int): (.bolster(for: components + [.constant(int)]), to.cardQuantity)
            case let .alterCardQuantity(int): (.bolster(for: components), (to.cardQuantity + int) < 1 ? 1 : (to.cardQuantity + int))
            default: to
            }
            
        case let .movement(amt):
            switch self {
            case let .alterMagnitude(int): (.movement(for: amt + int), to.cardQuantity)
            case let .alterCardQuantity(int): (.movement(for: amt), (to.cardQuantity + int) < 1 ? 1 : (to.cardQuantity + int))
            default: to
            }
            
        default: to
        }
    }
}
