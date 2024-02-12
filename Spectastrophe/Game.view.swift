//
//  ContentView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var encounter: Encounter
    @ObservedObject var player: Pawn

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            BoardView(encounter: encounter, player: player)
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
        }
        .background {
            Image("parchment-dark").resizable().scaledToFit()
        }
        .ignoresSafeArea()
        .overlay {
            if player.hp <= 0 {
                Color(.black)
                    .opacity(0.25)
                    .ignoresSafeArea()
                    .overlay {
                        VStack {
                            Text("Game Over")
                                .font(.largeTitle)
                                .bold()
                            Button("New Game") {
                                // TODO: start a new game
                            }
                        }
                    }
            } else {
                HUDView(encounter: encounter, player: player)
            }
        }
    }
}

#Preview {
    let player = Pawn(.player)
    let world = [Coords: Encounter]()
    let location = Coords(0,0)
    let game: GameState = GameState(player: player, world: world, location: location)
    
    return GameView(encounter: game.world[game.location] ?? Encounter(Coords(0,0), player: player), player: game.player)

}
