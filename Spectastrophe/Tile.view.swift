//
//  TileView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct TileView: View {
    var tile: Tile
    @ObservedObject var player: Pawn
    var enemies: [Pawn]
    
    @ViewBuilder var Tile: some View {
        Image("grassytile").resizable().scaledToFit().contentShape(TileTappableArea())
    }
    
    @ViewBuilder var SelectableTile: some View {
        Image("grassytile-can-select").resizable().scaledToFit().contentShape(TileTappableArea())
    }
    
    var body: some View {
        Tile
            .overlay {
                    if player.isMovingWith != nil && player.tile!.isAdjacent(to: tile.id) {
                        SelectableTile
                            .onTapGesture {
                                withAnimation {
                                    player.tile = tile.id
                                    player.isMovingWith = nil
                                }
                            }
                    }
                    
                    if player.isAttackingWith != nil {
                        ForEach(enemies) { enemy in
                            if enemy.tile == tile.id && tile.isInRangeOfAction(from: player.tile!, range: player.isAttackingWith!.range ?? []) {
                                SelectableTile
                                    .onTapGesture {
                                        if let action = player.isAttackingWith?.action {
                                            withAnimation {
                                                action.perform(by: player, on: [enemy])
                                                player.isAttackingWith = nil
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
    let tile = Tile(id: Coords(0,0))
    let player = Pawn(.player)
    let enemies = [Pawn(.enemy)]

//    return TileView(tile: tile, player: player, enemies: enemies)
    
    
    struct SelectableTile: View {
        var body: some View {
            Image("grassytile-can-select").resizable().scaledToFit()
        }
    }
    
    return SelectableTile()
        .frame(width: 600, height: 600)
        .contentShape(TileTappableArea())
        .overlay {
            TileTappableArea()
    }
}
