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
    
    @ViewBuilder var GrassyTile: some View {
        Image("tile-grassy").resizable().scaledToFit().contentShape(TileTappableArea())
    }
    
    @ViewBuilder var WaterTile: some View {
        Image("tile-water").resizable().scaledToFit().contentShape(TileTappableArea())
    }
    
    @ViewBuilder var SelectableTile: some View {
        TileTappableArea()
            .fill(Color.white.opacity(0.1)) // if I make this Color.clear, it won't register hits correctly. TODO: fascinating, investigate this later
            .stroke(Color.black, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
    }
    
    var body: some View {
        if tile.isTraversable {
            GrassyTile
                .overlay {
                    if player.isMovingWith != nil && player.tile!.isAdjacent(to: tile.id) && !enemies.contains(where: {$0.tile == tile.id}){
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
                                        if let action = player.isAttackingWith?.primaryAction {
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
        } else {
            WaterTile
        }
    }
}

#Preview {
    let tile = Tile(id: Coords(0,0), isTraversable: true)
    let player = Pawn(.player)
    let enemies = [Pawn(.enemy)]

    return TileView(tile: tile, player: player, enemies: enemies)
    
    
//    struct SelectableTile: View {
//        var body: some View {
//            Image("grassytile-can-select").resizable().scaledToFit()
//        }
//    }
//    
//    return SelectableTile()
//        .frame(width: 600, height: 600)
//        .contentShape(TileTappableArea())
//        .overlay {
//            TileTappableArea()
//    }
}
