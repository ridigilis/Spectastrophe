//
//  Board.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

struct Board {
    let tiles: [Coords: Tile]
    let byRow: [[Tile]]

    // creates a contrived hexagonal shaped board
    // I want this to be procedural in the future
    init() {
        var tiles: [Coords: Tile] = [:]
        var byRow: [Int: [Tile]] = [:]
        for row in -6...6 {
            for col in -6...6 {
                let coords = Coords(col, row)
                let tile = Tile(id: coords)

                tiles[coords] = tile
                if byRow[row] == nil {
                    byRow[row] = []
                }
                var byRowAtRow = byRow[row]
                byRowAtRow!.append(tile)
                byRow[row] = byRowAtRow
            }
        }
        self.tiles = tiles
        self.byRow = byRow.sorted { $0.key < $1.key }.map { row in
            row.value.filter {
                if $0.id.y > 0 {
                    return $0.id.x <= 6 - $0.id.y
                } else {
                    return $0.id.x >= -6 - $0.id.y
                }
            } }.reversed()
    }

    // TODO: this seems to be working, but might need some love later
    func shortestPath(from: Tile, to: Tile, _ closed: [Coords:Bool] = [:], _ path: [Tile] = []) -> [Tile]{
        let currentTile = path.last ?? from

        if currentTile == to {
            return path
        }

        if currentTile.id.isAdjacent(to: to.id) {
            return path + [to]
        }

        //

        let adjacentCoords = currentTile.id.allAdjacentCoords

        let scored: [(Coords, UInt)] = adjacentCoords
            .filter { closed[$0] == true ? false : true }
            .map { coords in
                print("to, cur", to.id, currentTile.id)
                return (coords, UInt(abs(to.id.x - coords.x) + abs(to.id.y - coords.y)))
            }

        let best = scored.min { a, b in a.1 < b.1 }

        var newClosed = closed
        adjacentCoords.forEach { coords in
            newClosed[coords] = true
        }

        if self.tiles[best!.0] != nil {
            return shortestPath(from: from, to: to, newClosed, path + [tiles[best!.0]!])
        } else {
            return []
        }

    }
}
