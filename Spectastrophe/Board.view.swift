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
    
    @State private var tileWidth: CGFloat = 80
    @State private var tileHeight: CGFloat = 80
    
    @Namespace private var animation
    
    private var rows: [[Coords]] {
        encounter.board.getStaticRows()
    }

    var body: some View {
        VStack {
            Image("tile-water").resizable().scaledToFit().hidden()
        }.frame(width: 2000, height: 1600)
            .id("anchor")
            .overlay{
                LazyVStack(spacing: -36) {
                    ForEach(encounter.board.byRow, id: \.self) { row in
                        LazyHStack(spacing: -16) {
                            ForEach(row, id: \.self
                            ) { tile in
                                if tile.coords.x > Int(player.coords!.x + 12)
                                    || tile.coords.x < Int(player.coords!.x - 12)
                                    || tile.coords.y > Int(player.coords!.y + 12)
                                    || tile.coords.y < Int(player.coords!.y - 12)
                                    || tile.coords.x + tile.coords.y > 12 + player.coords!.x + player.coords!.y
                                    || tile.coords.x + tile.coords.y < -12 + player.coords!.x + player.coords!.y
                                {
                                    Rectangle().frame(width: tileWidth, height: tileHeight).hidden()
                                } else if tile.coords.x > Int(player.coords!.x + 10)
                                            || tile.coords.x < Int(player.coords!.x - 10)
                                            || tile.coords.y > Int(player.coords!.y + 10)
                                            || tile.coords.y < Int(player.coords!.y - 10)
                                            || tile.coords.x + tile.coords.y > 10 + player.coords!.x + player.coords!.y
                                            || tile.coords.x + tile.coords.y < -10 + player.coords!.x + player.coords!.y
                                {
                                    Image("tile-water").resizable().scaledToFit().frame(width: tileWidth, height: tileHeight).opacity(0.4)
                                } else {
                                    TileView(tile: tile, player: player, enemies: encounter.enemies)
                                        .frame(width: tileWidth, height: tileHeight)
                                        .overlay(alignment: .bottom) {
                                            if player.coords == tile.coords {
                                                PawnView(pawn: player)
                                                    .matchedGeometryEffect(id: player.id, in: animation).offset(y: 6)
                                            }
                                            
                                            ForEach(encounter.enemies) { enemy in
                                                if enemy.coords == tile.coords {
                                                    PawnView(pawn: enemy)
                                                        .matchedGeometryEffect(id: enemy.id, in: animation)
                                                        .offset(y: 6)
                                                        .onTapGesture {
                                                            if enemy.hp <= 0 && player.coords == enemy.coords && player.op >= 2 {
                                                                player.deck.hand += [enemy.deck.equipment.mainhand] as? [any Card] ?? []
                                                                player.deck.hand += [enemy.deck.equipment.offhand] as? [any Card] ?? []
                                                                player.deck.hand += [enemy.deck.equipment.head] as? [any Card] ?? []
                                                                player.deck.hand += [enemy.deck.equipment.torso] as? [any Card] ?? []
                                                                player.deck.hand += [enemy.deck.equipment.hands] as? [any Card] ?? []
                                                                player.deck.hand += [enemy.deck.equipment.feet] as? [any Card] ?? []
                                                                player.op -= 2
                                                                encounter.enemies = encounter.enemies.filter { $0.id != enemy.id }
                                                            }
                                                        }
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
                                                if (tile.coords.x > Int(player.coords!.x + 10)
                                                    || tile.coords.x < Int(player.coords!.x - 10)
                                                    || tile.coords.y > Int(player.coords!.y + 10)
                                                    || tile.coords.y < Int(player.coords!.y - 10)
                                                    || tile.coords.x + tile.coords.y > 10 + player.coords!.x + player.coords!.y
                                                    || tile.coords.x + tile.coords.y < -10 + player.coords!.x + player.coords!.y)
                                                {
                                                    EmptyView()
                                                } else if card.coords == tile.coords {
                                                    Image(image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(24)
                                                        .offset(y: -24)
                                                        .shadow(radius: 12, y: 24)
                                                        .onTapGesture {
                                                            if player.coords == card.coords && player.op >= 1 {
                                                                withAnimation {
                                                                    player.deck.hand += [card.card]
                                                                    player.op -= 1
                                                                    encounter.cards = encounter.cards.filter { $0.coords != card.coords }
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
    }
}

#Preview {
    let player = Pawn(.player, maxHp: 120, tile: Coords(0,0))
    let encounter = Encounter(Coords(0,0), player: player)
    
    return BoardView(encounter: encounter, player: player)
}
