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
        
        for n in 0...100 {
            let coordsToAppend: [Coords] = Coords(0,0).getBoundaryCoords(at: UInt(n))
            coordsToAppend.forEach { coords in
                tiles[coords] = Tile(id: coords, isTraversable: Die.d100.roll()[0] >= 10)
            }
        }
        
        for row in -100...100 {
            let colCount = row.isMultiple(of: 2) ? 200 : 199
            let colStart = Double((-100 - row) / 2).rounded(.down)
            for col in Int(colStart)...(colCount + Int(colStart)) {
                let coords = Coords(col, row)

                if tiles[coords] == nil {
                    tiles[coords] = Tile(id: coords, isTraversable: false)
                }
                if byRow[row] == nil {
                    byRow[row] = []
                }
                var byRowAtRow = byRow[row]
                byRowAtRow!.append(tiles[coords]!)
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
