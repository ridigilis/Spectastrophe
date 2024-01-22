//
//  BoardView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    var body: some View {
        // TODO: figure out how to make the grid remain static and not reposition the tiles when a pawn moves to/from the center row
        Grid {
            ForEach(encounter.board.byRow, id: \.self) { row in
                GridRow {
                    HStack{
                        Spacer()
                        ForEach(row) { tile in
                            TileView(tile: tile, player: player, enemies: encounter.enemies)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    let player = Pawn(.player, maxHp: 120, tile: Coords(0,0))
    let encounter = Encounter(Coords(0,0), player: player)
    
    return BoardView(encounter: encounter, player: player)
}
