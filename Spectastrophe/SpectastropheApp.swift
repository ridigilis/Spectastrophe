//
//  SpectastropheApp.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

@main
struct SpectastropheApp: App {
    @StateObject var game: GameState = GameState(
        player: Pawn(.player),
        world: [Coords: Encounter](),
        location: Coords(0,0)
    )
    var body: some Scene {
        WindowGroup {
            ContentView(encounter: game.world[game.location]!, player: game.player)
        }
    }
}
