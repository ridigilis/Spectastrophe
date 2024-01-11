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

final class GameState: ObservableObject {
    var player: Pawn
    var world: OverWorld

    init(player: Pawn = Pawn(type: .player), world: OverWorld? = nil) {
        self.player = player
        self.world = world ?? OverWorld(player)
    }
}

struct Pawn: Targettable, HasDeck {
    let type: PawnType
    let hp: Int
    let pos: Coords
    let moves: UInt

    let deck: Deck

    init(_ prev: Self? = nil, type: PawnType? = nil, hp: Int? = nil, pos: Coords? = nil, moves: UInt? = nil, deck: Deck? = nil) {
        self.type = type ?? prev?.type ?? .enemy
        self.hp = hp ?? prev?.hp ?? 0
        self.pos = pos ?? prev?.pos ?? Coords(0,0)
        self.moves = moves ?? prev?.moves ?? 0
        self.deck = deck ?? prev?.deck ?? Deck()
    }

    enum PawnType {
        case player, enemy
    }
}

struct Deck {
	let drawPile: DrawPile
    let hand: Hand
	let playArea: PlayArea
	let discardPile: DiscardPile
	let exhaustPile: ExhaustPile

	init(_ deck: Deck? = nil, 
         drawPile: DrawPile? = nil,
         hand: Hand? = nil,
         playArea: PlayArea? = nil,
         discardPile: DiscardPile? = nil,
         exhaustPile: ExhaustPile? = nil
    ) {
        self.drawPile = drawPile ?? deck?.drawPile ?? DrawPile([
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
            Card(type: .action, actions: [GainMoves()]),
        ])
        self.hand = hand ?? deck?.hand ?? Hand()
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

    func discardFromHand(_ card: Card) -> Self {
        Self(self,
             hand: Hand(self.hand.cards.filter { $0 != card }),
             discardPile: DiscardPile(self.discardPile.cards + [card].compactMap{$0})
        )
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
        let cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }

        func draw() -> Card? {
            self.cards.first
        }
    }

    struct Hand: Pile {
        let cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    struct PlayArea: Pile {
        let cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    struct DiscardPile: Pile {
        let cards: [Card]

        init(_ cards: [Card] = []) {
            self.cards = cards
        }
    }

    struct ExhaustPile: Pile {
        let cards: [Card]

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

struct OverWorld {
    let player: Pawn
    let encounter: Encounter

    init(_ player: Pawn? = nil, encounter: Encounter? = nil) {
        self.player = player ?? Pawn()
        self.encounter = encounter ?? Encounter(board: Board(layers: 7), player: player ?? Pawn())
    }

}
struct Encounter {
    let board: Board
    let player: Pawn
    let enemies: [Coords: Pawn] = [Coords(-3, 2): Pawn(hp: 64, pos: Coords(-3, 2), deck: Deck())]

    struct Tile {
        let id = UUID()
        let occupants: [Pawn]
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

    init(_ tiles: BoardMap? = nil, layers: UInt = 0) {
        // the recursive function takes too long beyond 7
        // luckily that was the max I was shooting for,
        // but need to find a better solution if I want to go higher
        let lyrs = layers > 7 ? 7 : layers
        if tiles == nil {
            self.tiles = Board.generateLayer(amt: lyrs)
        } else {
            self.tiles = tiles!
        }
    }
}

typealias BoardMap = [Coords: (any Tile)?]

protocol Tile: Identifiable, Hashable {
    var id: Coords { get }
}
struct BoardTile: Tile, Hashable {
    var id: Coords
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
}

protocol Targettable {
    var hp: Int { get }
    var pos: Coords { get }
    var moves: UInt { get }

    init(_: Self?, hp: Int?, pos: Coords?, moves: UInt?)
}

extension Targettable {
    init(_ s: Self? = nil, hp: Int? = nil, pos: Coords? = nil, moves: UInt? = nil) {
        self.init(
            s,
            hp: hp ?? s?.hp ?? 0,
            pos: pos ?? s?.pos ?? Coords(0,0),
            moves: moves ?? s?.moves ?? 0
            )
    }
}

protocol HasDeck {
	var deck: Deck { get }
}

protocol Pile {
    var cards: [Card] { get }
}

protocol Action {
    var type: ActionType { get }
    static func perform(on targets: [Pawn]) -> [Pawn]
}

enum ActionType {
    case attack, defend, heal, buff, debuff, move
}

struct GainMoves: Action {
    let type: ActionType = .move

    static func perform(on targets: [Pawn]) -> [Pawn] {
        if targets.isEmpty {
            []
        } else {
            targets.map { Pawn($0, moves: $0.moves + 1) }
        }
    }
}
