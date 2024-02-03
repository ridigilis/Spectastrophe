//
//  Coords.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

struct Coords: Hashable, Equatable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    var toE: Self {
        Self(self.x + 1, self.y)
    }
    var toSE: Self {
        Self(self.x + 1, self.y - 1)
    }
    var toSW: Self {
        Self(self.x, self.y - 1)
    }
    var toW: Self {
        Self(self.x - 1, self.y)
    }
    var toNW: Self {
        Self(self.x - 1, self.y + 1)
    }
    var toNE: Self {
        Self(self.x, self.y + 1)
    }

    func isAdjacent(to coords: Self) -> Bool {
        switch coords {
            case self.toE: return true
            case self.toW: return true
            case self.toNE: return true
            case self.toNW: return true
            case self.toSE: return true
            case self.toSW: return true
            default: return false
        }
    }

    var allAdjacentCoords: [Self] {
        [
            self.toE,
            self.toSE,
            self.toSW,
            self.toW,
            self.toNW,
            self.toNE
        ]
    }
}
