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
        LazyVStack(spacing: -44) {
            ForEach(encounter.board.byRow, id: \.self) { row in
                LazyHStack(spacing: -19) {
                    ForEach(row) { tile in
                        TileView(tile: tile, player: player, enemies: encounter.enemies)
                                .frame(width: 96, height: 96)
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
