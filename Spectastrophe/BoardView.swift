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
        ForEach(encounter.board.byRow, id: \.self) { row in
            HStack {
                ForEach(row) { tile in
                    TileView(tile: tile, player: player, enemies: encounter.enemies)
                }
            }
        }
    }
}

#Preview {
    BoardView()
}
