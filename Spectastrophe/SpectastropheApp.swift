//
//  SpectastropheApp.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/4/24.
//

import SwiftUI

@main
struct SpectastropheApp: App {
    @State private var isPlaying = false
    @StateObject var game: GameState = GameState(
        player: Pawn(.player, maxHp: 60, tile: Coords(0,0), deck: Deck(drawPile: [
            GearCard(gear: Gear(slot: .wearable(.head))),
            GearCard(gear: Gear(slot: .wearable(.torso))),
            GearCard(gear: Gear(slot: .wearable(.hands))),
            GearCard(gear: Gear(slot: .wearable(.feet))),
            GearCard(gear: Gear(slot: .armament(.mainhand))),
            ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
            ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
        ])),
        world: [Coords: Encounter](),
        location: Coords(0,0)
    )
    
    var body: some Scene {
        WindowGroup {
            if !isPlaying {
                MainMenuView(isPlaying: $isPlaying)
            } else {
                GameView(encounter: Encounter(game.location, enemies: [
                    Pawn(.enemy, maxHp: 24, tile: Coords(-3, 6), deck: Deck(drawPile: [
                        GearCard(gear: Gear(slot: .wearable(.head))),
                        GearCard(gear: Gear(slot: .wearable(.torso))),
                        GearCard(gear: Gear(slot: .wearable(.hands))),
                        GearCard(gear: Gear(slot: .wearable(.feet))),
                        GearCard(gear: Gear(slot: .armament(.mainhand))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                    ])),
                    Pawn(.enemy, maxHp: 24, tile: Coords(2, 4), deck: Deck(drawPile: [
                        GearCard(gear: Gear(slot: .wearable(.head))),
                        GearCard(gear: Gear(slot: .wearable(.torso))),
                        GearCard(gear: Gear(slot: .wearable(.hands))),
                        GearCard(gear: Gear(slot: .wearable(.feet))),
                        GearCard(gear: Gear(slot: .armament(.mainhand))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                    ])),
                    Pawn(.enemy, maxHp: 24, tile: Coords(0, -4), deck: Deck(drawPile: [
                        GearCard(gear: Gear(slot: .wearable(.head))),
                        GearCard(gear: Gear(slot: .wearable(.torso))),
                        GearCard(gear: Gear(slot: .wearable(.hands))),
                        GearCard(gear: Gear(slot: .wearable(.feet))),
                        GearCard(gear: Gear(slot: .armament(.mainhand))),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                        ActionCard(title: "Move", description: "Move to an adjacent space", primaryAction: .movement(for: 1)),
                    ])),
                ], player: game.player), player: game.player)
                .background {
                    Image("tabletop").resizable().scaledToFill().ignoresSafeArea()
                }
            }
        }
    }
}
