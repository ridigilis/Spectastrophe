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

    var body: some View {
        ForEach(encounter.board.byRow, id: \.self) { row in
            HStack {
                ForEach(row) { tile in
                    TileView(tile: tile, player: player, enemies: encounter.enemies)
                }
            }
        }
    }
}

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
                PlayerView(player: player)
            }

            ForEach(enemies) { enemy in
                if enemy.tile == tile.id {
                    EnemyView(enemy: enemy).onTapGesture {
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

struct PlayerView: View {
    @ObservedObject var player: Pawn
    var body: some View {
        if player.hp <= 0 {
            Text("☠️")
        } else {
            Image(systemName: "person").resizable().scaledToFit()
        }
    }
}

struct EnemyView: View {
    @ObservedObject var enemy: Pawn
    var body: some View {
        if enemy.hp <= 0 {
            Text("☠️")
        } else {
            Image(systemName: "person").resizable().scaledToFit().foregroundStyle(Color(.red))
        }
    }
}

struct CardView: View {
    var card: Card
    @ObservedObject var player: Pawn

    @State private var fill = Color.brown

    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(fill)
                .frame(width:120, height: 180)
                .shadow(radius: 12)
            VStack {
                Text(card.title)
                    .frame(alignment: .topLeading)
                    .bold()
                    .padding(.bottom)
                    .padding(.bottom)

                Text(card.description)
                    .font(.footnote)
                    .padding(.bottom)
                    .padding(.bottom)
            }
        }
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    if player.turnToPlay {
                        dragAmount = $0.translation
                        if dragAmount.height < -200 {
                            fill = Color.teal
                        } else {
                            fill = Color.brown
                        }
                    }
                }
                .onEnded { _ in
                    if player.turnToPlay {
                        if dragAmount.height < -200 {
                            card.actions.forEach { action in
                                switch action {
                                    case .attack:
                                        player.isAttacking.toggle()
                                        player.isAttackingWith = action
                                    case .movement: action.perform(by: player, on: [player])
                                    default: return
                                }
                            }
                            player.deck.playFromHand(card)
                        }

                        fill = Color.brown
                        dragAmount = .zero
                    }
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

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
                VStack {
                    BoardView(encounter: encounter, player: player)
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

                        Button(player.isMoving ? "Moving" : "Move (\(player.moves))") {
                            player.isMoving.toggle()
                        }.disabled(player.moves == 0)


                    }

                    HStack {
                        Spacer()
                        Button("End Turn") {
                            encounter.onExitPlayPhase()
                        }.disabled(!player.turnToPlay)
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
