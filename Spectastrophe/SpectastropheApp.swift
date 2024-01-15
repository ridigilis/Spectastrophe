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
        player: Pawn(.player, hp: 120, tile: Coords(0,0)),
        world: [Coords: Encounter](),
        location: Coords(0,0)
    )
    var body: some Scene {
        WindowGroup {
            ContentView(encounter: Encounter(game.location, enemies: [Pawn(.enemy, hp: 60, tile: Coords(-3, 6))], player: game.player), player: game.player)
        }
    }
}
