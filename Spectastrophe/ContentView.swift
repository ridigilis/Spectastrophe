//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    var playerIsMoving: Bool

    var body: some View {
        ForEach(encounter.board.byRow, id: \.self.indices) { row in
            HStack {
                ForEach(row) { tile in
                    TileView(tile: tile, player: player, enemies: encounter.enemies, playerIsMoving: playerIsMoving)
                }
            }
        }
    }
}

struct TileView: View {
    var tile: Board.BoardTile
    var player: Pawn
    var enemies: [Coords: Pawn]
    var playerIsMoving: Bool

    var body: some View {
        Spacer().frame(width: 4)

        ZStack {
            Circle().fill(.gray).padding(-4)
            if playerIsMoving && player.tile!.isAdjacent(to: tile.id) {
                Circle().fill(.green).padding(-4)
            }
            if player.tile == tile.id {
                PlayerView()
            }
            if enemies[tile.id] != nil {
                EnemyView()
            }
        }

        Spacer().frame(width: 8)
    }
}

struct PlayerView: View {
    var body: some View {
        Image(systemName: "person").resizable().scaledToFit()
    }
}

struct EnemyView: View {
    var body: some View {
        Image(systemName: "person").resizable().scaledToFit().foregroundStyle(Color(.red))
    }
}

struct CardView: View {
    var card: Card
    @ObservedObject var player: Pawn

    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            .frame(width:120, height: 180)
            .foregroundColor(.brown)
            .shadow(radius: 12)
            .onTapGesture {
                card.actions.forEach { action in
                    action.perform(on: [player])
                }

                player.deck.discardFromHand(card)
            }
    }
}

struct HandView: View {
    @ObservedObject var hand: Deck.Hand
    @ObservedObject var player: Pawn

    var body: some View {
        HStack {
            ForEach(hand.cards) { card in
                CardView(card: card, player: player)
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    @State private var playerIsMoving = false

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
                VStack {
                    BoardView(encounter: encounter, player: player, playerIsMoving: playerIsMoving)
                }
                .aspectRatio(contentMode: .fit)
                .scaleEffect(currentZoom + totalZoom)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            currentZoom = value.magnification - 1
                        }
                        .onEnded { value in
                            totalZoom += currentZoom
                            currentZoom = 0
                        }
                )
                .accessibilityZoomAction { action in
                    if action.direction == .zoomIn {
                        totalZoom += 1
                    } else {
                        totalZoom -= 1
                    }
                }

                VStack {
                    Spacer()
                    HandView(hand: player.deck.hand, player: player)
                }

                VStack {
                    HStack {
                        Spacer()

                        Button(playerIsMoving ? "Moving" : "Move (\(player.moves))") {
                            playerIsMoving.toggle()
                        }.disabled(player.moves == 0)


                    }

                    HStack {
                        Spacer()
                        Button("End Turn") {

                        }
                    }

                    Spacer()
                }
                .padding(24)
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
    }
}

#Preview {
    var game: GameState = GameState()
    return ContentView(encounter: game.world[game.location]!, player: game.player)
}
