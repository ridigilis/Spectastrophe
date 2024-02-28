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
        var initTiles: [Coords: Tile] = [:]
        var initByRow: [Int: [Tile]] = [:]
        
        for n in 0...60 {
            let coordsToAppend: [Coords] = Coords(0,0).getBoundaryCoords(at: UInt(n))
            coordsToAppend.forEach { coords in
                if initTiles[coords] == nil {
                    initTiles[coords] = Tile(coords: coords, isTraversable: Die.d100.roll()[0] >= 10)
                }
            }
        }
        
        for row in -66...66 {
            let colCount = row.isMultiple(of: 2) ? 132 : 131
            let colStart = row.isMultiple(of: 2) ? -66 - Double(row / 2) : -66 - Double((row - 1) / 2)
            for col in Int(colStart)...(colCount + Int(colStart)) {
                let coords = Coords(col, row)

                if initTiles[coords] == nil {
                    initTiles[coords] = Tile(coords: coords, isTraversable: false)
                }
                if initByRow[row] == nil {
                    initByRow[row] = []
                }
                var byRowAtRow = initByRow[row]
                byRowAtRow!.append(initTiles[coords]!)
                initByRow[row] = byRowAtRow
            }
        }
        self.tiles = initTiles
        self.byRow = initByRow
            .sorted { a, b in a.key < b.key }
            .map { row in row.value }
            .reversed()
    }
    
    func getStaticRows(center coords: Coords = Coords(0,0)) -> [[Coords]] {
        var boundaryCoords: [Coords] = []
        for n in 0...16 {
            boundaryCoords += coords.getBoundaryCoords(at: UInt(n))
        }
        
        boundaryCoords = Array(Set(boundaryCoords))
        
        let max = boundaryCoords.max { a, b in a.y < b.y }
        var rows: [[Coords]] = []
        for n in 0...32 {
            let row: [Coords] = boundaryCoords.filter { c in c.y == max!.y - n}.sorted { a, b in a.x < b.x }
            rows.append(row)
        }
        return rows
    }
    
    func getRows(center coords: Coords) -> [[Tile]]{
        var boundaryCoords: [Coords] = []
        for n in 0...10 {
            boundaryCoords += coords.getBoundaryCoords(at: UInt(n))
        }
        
        boundaryCoords = Array(Set(boundaryCoords))
        
        let max = boundaryCoords.max { a, b in a.y < b.y }
        var rows: [[Tile]] = []
        for n in 0...20 {
            let row: [Tile] = boundaryCoords.filter { c in c.y == max!.y - n}.sorted { a, b in a.x < b.x }.map { c in self.tiles[c]! }
            rows.append(row)
        }
        return rows
    }
    
    // TODO: this seems to be working, but might need some love later
    func shortestPath(from: Tile, to: Tile, _ closed: [Coords:Bool] = [:], _ path: [Tile] = []) -> [Tile]{
        let currentTile = path.last ?? from

        if currentTile == to {
            return path
        }

        if currentTile.coords.isAdjacent(to: to.coords) {
            return path + [to]
        }

        //

        let adjacentCoords = currentTile.coords.allAdjacentCoords

        let scored: [(Coords, UInt)] = adjacentCoords
            .filter { self.tiles[$0]?.isTraversable ?? false }
            .filter { closed[$0] == true ? false : true }
            .compactMap { coords in
                return (coords, UInt(abs(to.coords.x - coords.x) + abs(to.coords.y - coords.y)))
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
