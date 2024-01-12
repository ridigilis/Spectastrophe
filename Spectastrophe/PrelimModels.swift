/*
Let's start with the bones. The stuff and things I know will be in the game regardless of where iteration takes it.
- There will be a PLAYER.
- The PLAYER will have a DECK of CARDS.
- The PLAYER will engage in ENCOUNTERS.
- ENCOUNTERS take place in hex TILE arenas.
- ENCOUNTERS will have ENEMIES.
- The PLAYER and ENEMIES will take turns playing all CARDS from their HAND.
- Playing CARDS from HAND will trigger various ACTIONS.
- ACTIONS include movement/navigation around the ENCOUNTER arena.
- ACTIONS also include ways to increase or decrease other resources that can be used for various reasons.
- ACTIONS also include ways for the PLAYER to engage with ENEMIES and viceversa, like attacks and spells.
- ACTIONS more often than not will trigger dice rolls that determine the result of the action.
- Some CARDS that are played go to the DISCARD PILE.
- When the DECK has been depleted, the DISCARD PILE is shuffled back into the DECK.
- Some CARDS can also be exhausted (removed from play entirely) through various means.
- Some CARDS, when played, are equipped by the PLAYER. Let's call them GEAR CARDS.
- GEAR CARDS, when equipped, may add more CARDS to the PLAYER'S DECK of CARDS.
- The PLAYER will need to defeat all ENEMIES in an ENCOUNTER in order to move onto the next ENCOUNTER.
- ENEMIES and the PLAYER are considered defeated when their hit points reach zero or less.
- ENEMIES may drop CARDS from their own DECK when defeated.
- The PLAYER can pick up dropped CARDS if they are on the TILE with the drop on it.
- The PLAYER may also be rewarded with CARDS after completing an ENCOUNTER.
- The PLAYER will choose which ENCOUNTER to attempt next on the OVERWORLD/MAP after completing an ENCOUNTER.

I think that's plenty to work with for now. Let's make some models!
*/

import Foundation
import SwiftUI

typealias World = [Coords: Encounter]

final class GameState: ObservableObject {
    @Published var player: Pawn

    @Published var world: World
    @Published var location: Coords

    init(player: Pawn = Pawn(.player, tile: Coords(0,0)), world: World = [Coords(0,0): Encounter(Coords(0,0), board: Board(layers: 7))], location: Coords = Coords(0,0)) {
        self.player = player
        self.world = world
        self.location = location
    }
}

final class Pawn: Targettable, HasDeck, ObservableObject {
    let id: UUID
    let type: PawnType

    @Published var hp: Int
    @Published var tile: Coords?
    @Published var moves: UInt

    @Published var deck: Deck

    init(_ type: PawnType = .enemy, hp: Int = 0, tile: Coords? = nil, moves: UInt = 0, deck: Deck = Deck()) {
        self.id = UUID()
        self.type = type
        self.hp = hp
        self.tile = tile
        self.moves = moves
        self.deck = deck
    }

    enum PawnType {
        case player, enemy
    }
}

final class Deck: ObservableObject {
    @Published var drawPile: DrawPile
    @Published var hand: Hand
    @Published var playArea: PlayArea
    @Published var discardPile: DiscardPile
    @Published var exhaustPile: ExhaustPile

	init(_ deck: Deck? = nil, 
         drawPile: DrawPile? = nil,
         hand: Hand? = nil,
         playArea: PlayArea? = nil,
         discardPile: DiscardPile? = nil,
         exhaustPile: ExhaustPile? = nil
    ) {
        self.drawPile = drawPile ?? deck?.drawPile ?? DrawPile()
        self.hand = hand ?? deck?.hand ?? Hand([
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
        ])
        self.playArea = playArea ?? deck?.playArea ?? PlayArea()
        self.discardPile = discardPile ?? deck?.discardPile ?? DiscardPile()
        self.exhaustPile = exhaustPile ?? deck?.exhaustPile ?? ExhaustPile()
	}

    func draw() -> Self {
        let card = self.drawPile.draw()

        return Self(self,
             drawPile: DrawPile(self.drawPile.cards.filter { $0 != card }),
             hand: Hand(self.hand.cards + [card].compactMap{$0})
        )
    }

    func playFromHand(_ card: Card) -> Self {
        Self(self,
             hand: Hand(self.hand.cards.filter { $0 != card }),
             playArea: PlayArea(self.playArea.cards + [card].compactMap{$0})
        )
    }

    func discardFromHand(_ card: Card) {
        self.hand.cards = self.hand.cards.filter { $0 != card }
        self.discardPile.cards = self.discardPile.cards + [card].compactMap{$0}
    }

    func exhaust(_ card: Card) -> Self {
        Self(self,
             playArea: PlayArea(self.playArea.cards.filter { $0 != card }),
             exhaustPile: ExhaustPile(self.exhaustPile.cards + [card].compactMap{$0})
        )
    }

    func shuffleDrawPile() -> Self {
        Self(self,
             drawPile: DrawPile(self.drawPile.cards.shuffled())
        )
    }

    func shuffleDiscardPileIntoDrawPile() -> Self {
        let cards = self.drawPile.cards + self.discardPile.cards

        return Self(self,
                    drawPile: DrawPile(cards.shuffled()),
                    discardPile: DiscardPile()
        )
    }

    func discardHand() -> Self {
        Self(self,
             hand: Hand(),
             discardPile: DiscardPile(self.discardPile.cards + self.hand.cards)
        )
    }

    func clearPlayArea() -> Self {
        Self(self,
             playArea: PlayArea(),
             discardPile: DiscardPile(self.discardPile.cards + self.playArea.cards)
        )
    }

    struct DrawPile: Pile {
        var cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }

        func draw() -> Card? {
            self.cards.first
        }
    }

    final class Hand: Pile, ObservableObject {
        @Published var cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    struct PlayArea: Pile {
        var cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    final class DiscardPile: Pile, ObservableObject {
        @Published var cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    struct ExhaustPile: Pile {
        var cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }
}

struct Card: Equatable, Identifiable {
    let id = UUID()
    let parentId: UUID?
    let type: CardType
    let actions: [any Action]

    init(parentId: UUID? = nil, type: CardType, actions: [any Action]) {
        self.parentId = parentId
        self.type = type
        self.actions = actions
    }

    // not sure if this is what I want this to be yet
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    enum CardType {
        case action, gear
    }
}

final class Encounter: Identifiable, ObservableObject {
    let id: Coords
    @Published var board: Board
    @Published var enemies: [Coords: Pawn]

    @Published var turn: TurnState
    @Published var phase: PhaseState

    init(_ id: Coords, board: Board = Board(), enemies: [Coords: Pawn] = [:], turn: TurnState = .player, phase: PhaseState = .turnStart) {
        self.id = id
        self.board = board
        self.enemies = enemies
        self.turn = turn
        self.phase = phase
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

struct Board {
    let tiles: BoardMap
    let byRow: [[BoardTile]]

    static private func generateLayer(amt: UInt, coords: Coords = Coords(0,0), tiles: BoardMap = [:]) -> BoardMap {
        if amt == 0 {
            return tiles
        }

        let newAmt = amt - 1
        var t = tiles

        t[coords] = BoardTile(id: coords)

        return generateLayer(amt: newAmt, coords: coords.toE, tiles: t)
            .merging(generateLayer(amt: newAmt, coords: coords.toSE, tiles: t), uniquingKeysWith: { keep, _ in return keep })
            .merging(generateLayer(amt: newAmt, coords: coords.toSW, tiles: t), uniquingKeysWith: { keep, _ in return keep })
            .merging(generateLayer(amt: newAmt, coords: coords.toW, tiles: t), uniquingKeysWith: { keep, _ in return keep })
            .merging(generateLayer(amt: newAmt, coords: coords.toNW, tiles: t), uniquingKeysWith: { keep, _ in return keep })
            .merging(generateLayer(amt: newAmt, coords: coords.toNE, tiles: t), uniquingKeysWith: { keep, _ in return keep })
    }

    init(_ tiles: BoardMap = [:], layers: UInt = 0) {
        // the recursive function takes too long beyond 7
        // luckily that was the max I was shooting for,
        // but need to find a better solution if I want to go higher
        let lyrs = layers > 7 ? 7 : layers
        let t = Board.generateLayer(amt: lyrs)

        self.tiles = t

        let min = t.keys.map { $0.y }.min() ?? 0
        let max = t.keys.map { $0.y }.max() ?? 0

        var arr: [[BoardTile]] = []
        for row in min...max {
            arr.append(t.filter { $0.key.y == row }.map { $0.value }.sorted { $0.id.x < $1.id.x })
        }
        
        self.byRow = arr
    }

    typealias BoardMap = [Coords: BoardTile]
    struct BoardTile: Tile, Hashable {
        var id: Coords
    }
}

protocol Tile: Identifiable, Hashable {
    var id: Coords { get }
}

struct Coords: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    var toE: Self {
        Self(self.x + 1, self.y)
    }
    var toSE: Self {
        Self(self.x + 1, self.y - 1)
    }
    var toSW: Self {
        Self(self.x, self.y - 1)
    }
    var toW: Self {
        Self(self.x - 1, self.y)
    }
    var toNW: Self {
        Self(self.x - 1, self.y + 1)
    }
    var toNE: Self {
        Self(self.x, self.y + 1)
    }

    func isAdjacent(to coords: Coords) -> Bool {
        switch coords {
            case self.toE: return true
            case self.toW: return true
            case self.toNE: return true
            case self.toNW: return true
            case self.toSE: return true
            case self.toSW: return true
            default: return false
        }
    }
}

protocol Targettable {
    var hp: Int { get set }
    var tile: Coords? { get set }
    var moves: UInt { get set }
}

protocol HasDeck {
	var deck: Deck { get set }
}

protocol Pile {
    var cards: [Card] { get set }
}

protocol Action {
    var type: ActionType { get }
    func perform(on targets: [Pawn]) -> Void
}

enum ActionType {
    case attack, defend, heal, buff, debuff, move
}

struct GainMoves: Action {
    let type: ActionType = .move

    func perform(on targets: [Pawn]) {
        if targets.isEmpty {
            return
        } else {
            targets.forEach { $0.moves += 1 }
        }
    }
}
