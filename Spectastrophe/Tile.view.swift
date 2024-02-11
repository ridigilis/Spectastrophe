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
    
    func isTargettable(from coords: Coords, range: [Action.Range]) -> Bool {
        range.map {
            switch $0 {
            case .melee: coords.getBoundaryCoords(at: 1)
            case .reach: coords.getBoundaryCoords(at: 2)
            case let .ranged(distance):
                switch distance {
                case .short:
                    coords.getBoundaryCoords(at: 2) + coords.getBoundaryCoords(at: 3)
                    + coords.getBoundaryCoords(at: 4)
                case .medium:
                    coords.getBoundaryCoords(at: 4) + coords.getBoundaryCoords(at: 5)
                    + coords.getBoundaryCoords(at: 6)
                case .long:
                    coords.getBoundaryCoords(at: 6) + coords.getBoundaryCoords(at: 7)
                    + coords.getBoundaryCoords(at: 8)
                case .infinite:
                    [self.tile.id]
                }
            }
        }
        .reduce([Coords]()) { $0 + $1 }
        .contains(where: { $0 == self.tile.id })
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
                            if enemy.tile == tile.id && isTargettable(from: player.tile!, range: player.isAttackingWith!.range ?? []) {
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
