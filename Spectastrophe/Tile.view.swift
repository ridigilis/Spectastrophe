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
    
    @ViewBuilder var ClearTile: some View {
        Image("tile-water").resizable().scaledToFit().contentShape(TileTappableArea()).opacity(0).hidden()
    }
    
    @ViewBuilder var SelectableTile: some View {
        TileTappableArea()
            .fill(Color.white.opacity(0.1)) // if I make this Color.clear, it won't register hits correctly. TODO: fascinating, investigate this later
            .stroke(Color.black, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
            .zIndex(99999999)
    }
    
    var body: some View {
        if tile.coords.x > Int(player.coords!.x + 10)
        || tile.coords.x < Int(player.coords!.x - 10)
        || tile.coords.y > Int(player.coords!.y + 10)
        || tile.coords.y < Int(player.coords!.y - 10)
            || tile.coords.x + tile.coords.y > 10 + player.coords!.x + player.coords!.y
            || tile.coords.x + tile.coords.y < -10 + player.coords!.x + player.coords!.y
        {
            ClearTile
        } else {
            if tile.isTraversable {
                GrassyTile
                    .overlay {
                        if player.isMovingWith != nil && player.coords!.isAdjacent(to: tile.coords) && !enemies.filter({$0.hp > 0}).contains(where: {$0.coords == tile.coords}){
                            SelectableTile
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        player.coords = tile.coords
                                        player.bolsteredBy = 0
                                        player.isMovingWith = nil
                                    }
                                }
                        }
                        
                        if player.isAttackingWith != nil {
                            ForEach(enemies) { enemy in
                                if enemy.coords == tile.coords && tile.isInRangeOfAction(from: player.coords!, range: player.isAttackingWith!.range ?? []) {
                                    SelectableTile
                                        .onTapGesture {
                                            if let action = player.isAttackingWith?.primaryAction {
                                                withAnimation(.easeInOut) {
                                                    action.perform(by: player, on: [enemy])
                                                    player.bolsteredBy = 0
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
}

#Preview {
    let tile = Tile(coords: Coords(0,0), isTraversable: true)
    let player = Pawn(.player)
    let enemies = [Pawn(.enemy)]

    return TileView(tile: tile, player: player, enemies: enemies)
}
