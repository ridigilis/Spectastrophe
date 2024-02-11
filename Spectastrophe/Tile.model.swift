//
//  Tile.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

struct Tile: Identifiable, Hashable, Equatable {
    var id: Coords

    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
    
    func isInRangeOfAction(from coords: Coords, range: [Action.Range]) -> Bool {
        range.map {
            switch $0 {
            case .melee: coords.getBoundaryCoords(at: 1)
            case .reach: coords.getBoundaryCoords(at: 2)
            case let .ranged(distance):
                switch distance {
                case .short:
                    coords.getBoundaryCoords(at: 2) + coords.getBoundaryCoords(at: 3)
                    + coords.getBoundaryCoords(at: 4)
                case .medium:
                    coords.getBoundaryCoords(at: 4) + coords.getBoundaryCoords(at: 5)
                    + coords.getBoundaryCoords(at: 6)
                case .long:
                    coords.getBoundaryCoords(at: 6) + coords.getBoundaryCoords(at: 7)
                    + coords.getBoundaryCoords(at: 8)
                case .infinite:
                    [self.id]
                }
            }
        }
        .reduce([Coords]()) { $0 + $1 }
        .contains(where: { $0 == self.id })
    }
}
