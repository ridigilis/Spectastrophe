//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

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
