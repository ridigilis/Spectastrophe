//
//  Encounter.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

final class Encounter: Identifiable, ObservableObject {
    let id: Coords
    @Published var board: Board
    @Published var enemies: [Pawn]

    @Published var turn: TurnState
    @Published var phase: PhaseState

    private let player: Pawn

    init(_ id: Coords, board: Board = Board(), enemies: [Pawn] = [], turn: TurnState = .player, phase: PhaseState = .turnStart, player: Pawn) {
        self.id = id
        self.board = board
        self.enemies = enemies
        self.turn = turn
        self.phase = phase

        self.player = player

        self.onEnterTurnStart()
    }

    private func onEnterTurnStart() {
        //do something
        self.onExitTurnStart()
    }

    private func onExitTurnStart() {
        //do something
        self.phase = self.phase.next()
        self.onEnterDrawPhase()
    }

    private func onEnterDrawPhase() {
        //do something

        switch self.turn {
                // arbitrary amount for now
            case .player: self.player.deck.draw(3)

            case .enemy: self.enemies.filter { $0.hp > 0 }.forEach { $0.deck.draw(3) }
        }

        self.onExitDrawPhase()
    }

    private func onExitDrawPhase() {
        //do something
        self.phase = self.phase.next()
        self.onEnterPlayPhase()
    }

    private func onEnterPlayPhase() {
        //do something
        switch self.turn {
            case .player:
                self.player.turnToPlay.toggle()
                //but dont exit until the player decides to exit
                //or maybe automatically if no other moves can be made?
            case .enemy:
                self.enemies.filter { $0.hp > 0 }.forEach { enemy in
                    if !self.player.tile!.isAdjacent(to: enemy.tile!) {
                        let path = self.board.shortestPath(from: self.board.tiles[enemy.tile!]!, to: self.board.tiles[self.player.tile!]!)

                        if path.isEmpty {
                            return
                        }

                        for tile in path {
                            if let card = enemy.deck.hand.first(where: { $0.title == "Move"}) {
                                if !self.player.tile!.isAdjacent(to: enemy.tile!) {
                                    enemy.deck.playFromHand(card)
                                    enemy.tile = tile.id
                                }
                            } else {
                                break
                            }
                        }
                    }

                    if self.player.tile!.isAdjacent(to: enemy.tile!) {
                        enemy.deck.hand.forEach { card in
                            switch card.action {
                            case .attack:
                                enemy.deck.playFromHand(card)
                                card.action.perform(by: enemy, on: [self.player])
                            default:
                                return
                            }
                        }
                    }
                }

                self.phase = self.phase.next()
                self.onExitPlayPhase()
        }
    }

    func onExitPlayPhase() {
        //do something
        if self.turn == .player {
            self.player.turnToPlay.toggle()
        }
        self.player.deck.clearPlayArea()
        self.player.deck.discardHand()
        self.enemies.forEach { enemy in
            enemy.deck.clearPlayArea()
            enemy.deck.discardHand()
        }
        self.phase = self.phase.next()
        self.onEnterTurnEnd()
    }

    func onEnterTurnEnd() {
        //do something
        self.player.isMovingWith = nil
        self.enemies.forEach { enemy in
            enemy.isMovingWith = nil
        }
        self.onExitTurnEnd()
    }

    func onExitTurnEnd() {
        //do something
        self.phase = self.phase.next()
        self.turn = self.turn.next()
        self.onEnterTurnStart()
    }

    enum TurnState {
        case player, enemy

        func next() -> Self {
            if self == .player {
                return .enemy
            }
            return .player
        }

        func descriptor() -> String {
            switch self {
                case .player: return "Player's Turn"
                case .enemy: return "Enemy's Turn"
            }
        }
    }

    enum PhaseState: UInt {
        case turnStart, draw, play, turnEnd

        func next() -> PhaseState {
            if self == .turnEnd {
                return .turnStart
            }
            return Self(rawValue: self.rawValue + 1) ?? .turnStart
        }

        func descriptor() -> String {
            switch self {
                case .turnStart: return "Start of Turn"
                case .draw: return "Draw Phase"
                case .play: return "Play Phase"
                case .turnEnd: return "End of Turn"
            }
        }
    }
}
