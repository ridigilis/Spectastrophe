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

    var body: some View {
        Spacer().frame(width: 4)

        ZStack {
            Circle().fill(.gray).padding(-4)
            if player.isMoving && player.tile!.isAdjacent(to: tile.id) {
                Circle().fill(.green).padding(-4).onTapGesture {
                    player.tile = tile.id
                    player.moves -= 1
                    player.isMoving.toggle()
                }
            }

            if player.isAttacking && player.tile!.isAdjacent(to: tile.id) {
                ForEach(enemies) { enemy in
                    if enemy.tile == tile.id {
                        Circle().fill(.green).padding(-4)
                    } else {
                        Circle().fill(.red).padding(-4)
                    }
                }
            }

            if player.tile == tile.id {
                PawnView(pawn: player)
            }

            ForEach(enemies) { enemy in
                if enemy.tile == tile.id {
                    PawnView(pawn: enemy).onTapGesture {
                        if let action = player.isAttackingWith {
                            action.perform(by: player, on: [enemy])
                            player.isAttacking.toggle()
                            player.isAttackingWith = nil
                        }
                    }
                }
            }
        }

        Spacer().frame(width: 8)
    }
}

#Preview {
    let tile = Tile(id: Coords(0,0))
    let player = Pawn(.player)
    let enemies = [Pawn(.enemy)]

    return TileView(tile: tile, player: player, enemies: enemies)
}
