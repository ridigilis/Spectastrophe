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

    @Binding var playerIsMoving: Bool

    var body: some View {
        ForEach(encounter.board.byRow, id: \.self) { row in
            HStack {
                ForEach(row) { tile in
                    TileView(tile: tile, player: player, enemies: encounter.enemies, playerIsMoving: $playerIsMoving)
                }
            }
        }
    }
}

struct TileView: View {
    var tile: Tile
    var player: Pawn
    var enemies: [Coords: Pawn]
    @Binding var playerIsMoving: Bool

    var body: some View {
        Spacer().frame(width: 4)

        ZStack {
            Circle().fill(.gray).padding(-4)
            Text("\(tile.id.x), \(tile.id.y)")
            if playerIsMoving && player.tile!.isAdjacent(to: tile.id) {
                Circle().fill(.green).padding(-4).onTapGesture {
                    player.tile = tile.id
                    player.moves -= 1
                    playerIsMoving.toggle()
                }
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

    @State private var fill = Color.brown
    @State private var dragAmount = CGSize.zero

    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            .fill(fill)
            .frame(width:120, height: 180)
            .shadow(radius: 12)
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged {
                        dragAmount = $0.translation
                        if dragAmount.height < -200 {
                            fill = Color.teal
                        } else {
                            fill = Color.brown
                        }
                    }
                    .onEnded { _ in
                        if dragAmount.height < -200 {
                            card.actions.forEach { action in
                                action.perform(on: [player])
                            }
                            player.deck.playFromHand(card)
                        }

                        fill = Color.brown
                        dragAmount = .zero
                    }
            )
            .animation(.bouncy, value: dragAmount)
    }
}

struct HandView: View {
    @ObservedObject var deck: Deck
    @ObservedObject var player: Pawn

    var body: some View {
        HStack {
            ForEach(deck.hand) { card in
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
                    BoardView(encounter: encounter, player: player, playerIsMoving: $playerIsMoving)
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
                    HandView(deck: player.deck, player: player)
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
