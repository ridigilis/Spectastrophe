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
    
    @Namespace private var animation

    var body: some View {
        VStack(spacing: -10) {
            ForEach(encounter.board.byRow, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row) { tile in
                        TileView(tile: tile, player: player, enemies: encounter.enemies)
                            .frame(width: 60, height: 60)
                            .overlay(alignment: .bottom) {
                                if player.tile == tile.id {
                                    PawnView(pawn: player)
                                        .matchedGeometryEffect(id: player.id, in: animation)
                                }
                                
                                ForEach(encounter.enemies) { enemy in
                                    if enemy.tile == tile.id {
                                        PawnView(pawn: enemy)
                                            .matchedGeometryEffect(id: enemy.id, in: animation)
                                    }
                                }
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
