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
        GridLayout(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(encounter.board.byRow, id: \.self) { row in
                GridRow {
                    HStack{
                        ForEach(row) { tile in
                            TileView(tile: tile, player: player, enemies: encounter.enemies)
                                .frame(width: 60, height: 60)
                        }
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
