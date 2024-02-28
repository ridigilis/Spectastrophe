//
//  Rarity.model.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/9/24.
//

import Foundation

protocol Rarifiable {
    var rarity: Rarity { get }
    
    func determineRarity(with adjustment: Int?) -> Rarity
}

extension Rarifiable {
    func determineRarity(with adjustment: Int = 0) -> Rarity {
        Rarity.roll(with: adjustment)
    }
}

enum Rarity: String {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case veryrare = "Very Rare"
    case legendary = "Legendary"
    case mythical = "Mythical"
    
    static func roll(with adjustment: Int = 0) -> Self {
        let roll = Die.d20.sumRoll(6) + adjustment
        
        switch roll {
        case 110...: return .mythical
        case 100...109:  return .legendary
        case 90...99: return .veryrare
        case 80...89: return .rare
        case 70...79: return .uncommon
        default: return .common
        }
    }
}
