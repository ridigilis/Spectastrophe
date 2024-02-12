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

    init() {
        var tiles: [Coords: Tile] = [:]
        var byRow: [Int: [Tile]] = [:]
        for row in -12...12 {
            let colCount = row.isMultiple(of: 2) ? 24 : 23
            let colStart = Double((-12 - row) / 2).rounded(.down)
            for col in Int(colStart)...(colCount + Int(colStart)) {
                let coords = Coords(col, row)
                let tile = Tile(id: coords, isTraversable: Die.d100.roll()[0] >= 10)

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
        self.byRow = byRow
            .sorted { a, b in a.key < b.key }
            .map { row in row.value }
            .reversed()
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
            .filter { self.tiles[$0]?.isTraversable ?? false }
            .filter { closed[$0] == true ? false : true }
            .compactMap { coords in
                return (coords, UInt(abs(to.id.x - coords.x) + abs(to.id.y - coords.y)))
            }

        if let best = scored.min(by: { a, b in a.1 < b.1 }) {
            var newClosed = closed
            adjacentCoords.forEach { coords in
                newClosed[coords] = true
            }
            
            if self.tiles[best.0] != nil {
                return shortestPath(from: from, to: to, newClosed, path + [tiles[best.0]!])
            } else {
                return []
            }
        }
        return []
    }
}
