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
}
