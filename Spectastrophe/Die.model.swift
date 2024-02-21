//
//  Die.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

enum Die {
    case d0
    case d2
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case d100

    func roll(_ n: Int = 1) -> [Int] {
        var rolls: [Int] = Array<Int>()
        var fn: () -> Int

        switch self {
            case .d0:
                fn = { 0 }
            case .d2:
                fn = { Int.random(in: 0...1) }
            case .d4:
                fn = { Int.random(in: 1...4) }
            case .d6:
                fn = { Int.random(in: 1...6) }
            case .d8:
                fn = { Int.random(in: 1...8) }
            case .d10:
                fn = { Int.random(in: 0...9) }
            case .d12:
                fn = { Int.random(in: 1...12) }
            case .d20:
                fn = { Int.random(in: 1...20) }
            case .d100:
                fn = { Int.random(in: 0...99) }
        }

        for _ in 1...n {
            let result = fn()
            rolls.append(result)
        }

        return rolls
    }

    func sumRoll(_ n: Int) -> Int {
        return self.roll(n).reduce(0) { $0 + $1 }
    }
}
