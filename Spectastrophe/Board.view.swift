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
                                
                                ForEach(encounter.cards) { card in
                                    let image: String = switch card.card.rarity {
                                    case .mythical: "cardback-mythical"
                                    case .legendary: "cardback-legendary"
                                    case .veryrare: "cardback-veryrare"
                                    case .rare: "cardback-rare"
                                    case .uncommon: "cardback-uncommon"
                                    case .common: "cardback-generic"
                                    default: "cardback-common"
                                    }
                                    if card.coords == tile.id {
                                        Image(image)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(24)
                                            .offset(y: -24)
                                            .shadow(radius: 12, y: 24)
                                            .onTapGesture {
                                                if player.tile == card.coords && player.op >= 1 {
                                                    withAnimation {
                                                        player.deck.hand += [card.card]
                                                        player.op -= 1
                                                        encounter.cards = encounter.cards.filter { $0.id != card.id }
                                                    }
                                                }
                                                    
                                            }
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
