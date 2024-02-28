//
//  GameState.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

final class GameState: ObservableObject {
    @Published var player: Pawn
    @Published var world:[Coords: Encounter]
    @Published var location: Coords

    init(player: Pawn, world: [Coords: Encounter], location: Coords) {
        self.player = player
        self.world = world
        self.location = location
    }
    
    init() {
        let location = Coords(0,0)
        let player = Pawn(.player)
        
        self.player = player
        self.world = [
            location: Encounter(player: player)
        ]
        self.location = location
    }
    
    func newGame() {
        let location = Coords(0,0)
        self.location = location
        self.player = Pawn(.player)
        self.world = [location: Encounter(player: self.player)]
    }
}
