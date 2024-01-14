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

    init(player: Pawn = Pawn(.player, hp: 120, tile: Coords(0,0)), world: World? = nil, location: Coords = Coords(0,0)) {
        self.player = player
        self.world = world ?? [Coords(0,0): Encounter(Coords(0,0), board: Board(), enemies: [Pawn(hp: 60, tile: Coords(3,0))], player: player)]
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

    @Published var turnToPlay: Bool
    @Published var isMoving: Bool
    @Published var isAttacking: Bool
    @Published var isAttackingWith: Action?

    init(_ type: PawnType = .enemy, hp: Int = 0, tile: Coords? = nil, moves: UInt = 0, deck: Deck = Deck()) {
        self.id = UUID()
        self.type = type
        self.hp = hp
        self.tile = tile
        self.moves = moves
        self.deck = deck
        self.turnToPlay = false
        self.isMoving = false
        self.isAttacking = false
        self.isAttackingWith = nil
    }

    enum PawnType {
        case player, enemy
    }
}

final class Deck: ObservableObject {
    @Published var drawPile: [Card]
    @Published var hand: [Card]
    @Published var playArea: [Card]
    @Published var discardPile: [Card]
    @Published var exhaustPile: [Card]

    init(drawPile: [Card] = [
        Card(type: .action, title: "Move", description: "Gain 1 movement", actions: [.movement(for: .constant(1))]),
        Card(type: .action, title: "Move", description: "Gain 1 movement", actions: [.movement(for: .constant(1))]),
        Card(type: .action, title: "Move", description: "Gain 1 movement", actions: [.movement(for: .constant(1))]),
        Card(type: .action, title: "Slash", description: "Deal 1d4 damage", actions: [.attack(.physical(.slash), for: .random([.d4]))]),
        Card(type: .action, title: "Slash", description: "Deal 1d4 damage", actions: [.attack(.physical(.slash), for: .random([.d4]))])
    ].shuffled(),
         hand: [Card] = [],
         playArea: [Card] = [],
         discardPile: [Card] = [],
         exhaustPile: [Card] = []
    ) {
        self.drawPile = drawPile
        self.hand = hand
        self.playArea = playArea
        self.discardPile = discardPile
        self.exhaustPile = exhaustPile
	}

    private func drawCardFromTop() {
        let card = self.drawPile.first

        self.drawPile = self.drawPile.filter { $0 != card }
        self.hand = self.hand + [card].compactMap { $0 }
    }

    func draw(_ amt: UInt = 1) {
        for _ in 1...amt {
            if self.drawPile.count == 0 {
                self.shuffleDiscardPileIntoDrawPile()
            }
            self.drawCardFromTop()
        }
    }

    func playFromHand(_ card: Card) {
        self.hand = self.hand.filter { $0 != card }
        self.playArea = self.playArea + [card].compactMap { $0 }
    }

    func discardFromHand(_ card: Card) {
        self.hand = self.hand.filter { $0 != card }
        self.discardPile = self.discardPile + [card].compactMap{ $0 }
    }

    func exhaust(_ card: Card) {
        self.playArea = self.playArea.filter { $0 != card }
        self.exhaustPile = self.exhaustPile + [card].compactMap{ $0 }
    }

    func shuffleDrawPile() {
        self.drawPile = self.drawPile.shuffled()
    }

    func shuffleDiscardPileIntoDrawPile() {
        let cards = self.drawPile + self.discardPile

        self.drawPile = cards.shuffled()
        self.discardPile = []
    }

    func discardHand() {
        self.discardPile = self.discardPile + self.hand
        self.hand = []
    }

    func clearPlayArea() {
        self.discardPile = self.discardPile + self.playArea
        self.playArea = []
    }
}

struct Card: Equatable, Identifiable {
    let id = UUID()
    let parentId: UUID?
    let type: CardType
    let actions: [Action]
    let title: String
    let description: String

    init(parentId: UUID? = nil, type: CardType, title: String = "What does this card do?", description: String = "Nobody knows...", actions: [Action]) {
        self.parentId = parentId
        self.type = type
        self.actions = actions
        self.title = title
        self.description = description
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
                    enemy.deck.hand.forEach { card in
                        if card.title == "Move" {
                            enemy.deck.playFromHand(card)
                            card.actions.forEach { action in
                                action.perform(by: enemy, on: [enemy])
                            }
                        }
                    }

                    if !self.player.tile!.isAdjacent(to: enemy.tile!) {
                        let path = self.board.shortestPath(from: self.board.tiles[enemy.tile!]!, to: self.board.tiles[self.player.tile!]!)

                        if path.isEmpty {
                            return
                        }

                        for tile in path {
                            if enemy.moves > 0 {
                                enemy.tile = tile.id
                                enemy.moves -= 1
                            } else {
                                break
                            }
                        }
                    }

                    if self.player.tile!.isAdjacent(to: enemy.tile!) {
                        enemy.deck.hand.forEach { card in
                            if card.title == "Slash" {
                                enemy.deck.playFromHand(card)
                                card.actions.forEach { action in
                                    action.perform(by: enemy, on: [self.player])
                                }
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
        self.player.moves = 0
        self.enemies.forEach { enemy in
            enemy.moves = 0
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

struct Board {
    let tiles: [Coords: Tile]
    let byRow: [[Tile]]

    // creates a contrived hexagonal shaped board
    // I want this to be procedural in the future
    init() {
        var tiles: [Coords: Tile] = [:]
        var byRow: [Int: [Tile]] = [:]
        for row in -6...6 {
            for col in -6...6 {
                let coords = Coords(col, row)
                let tile = Tile(id: coords)

                tiles[coords] = tile
                if byRow[row] == nil {
                    byRow[row] = []
                }
                var byRowAtRow = byRow[row]
                byRowAtRow!.append(tile)
                byRow[row] = byRowAtRow
            }
        }
        self.tiles = tiles
        self.byRow = byRow.sorted { $0.key < $1.key }.map { row in
            row.value.filter {
                if $0.id.y > 0 {
                    return $0.id.x <= 6 - $0.id.y
                } else {
                    return $0.id.x >= -6 - $0.id.y
                }
            } }.reversed()
    }
    
    // TODO: this seems to be working, but might need some love later
    func shortestPath(from: Tile, to: Tile, _ closed: [Coords:Bool] = [:], _ path: [Tile] = []) -> [Tile]{
        let currentTile = path.last ?? from

        if currentTile == to {
            return path
        }

        if currentTile.id.isAdjacent(to: to.id) {
            return path + [to]
        }

        //

        let adjacentCoords = currentTile.id.allAdjacentCoords

        let scored: [(Coords, UInt)] = adjacentCoords
            .filter { closed[$0] == true ? false : true }
            .map { coords in
                print("to, cur", to.id, currentTile.id)
                return (coords, UInt(abs(to.id.x - coords.x) + abs(to.id.y - coords.y)))
            }

        let best = scored.min { a, b in a.1 < b.1 }

        var newClosed = closed
        adjacentCoords.forEach { coords in
            newClosed[coords] = true
        }

        if self.tiles[best!.0] != nil {
            return shortestPath(from: from, to: to, newClosed, path + [tiles[best!.0]!])
        } else {
            return []
        }

    }
}

struct Tile: Identifiable, Hashable, Equatable {
    var id: Coords

    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}

struct Coords: Hashable, Equatable {
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

    func isAdjacent(to coords: Self) -> Bool {
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

    var allAdjacentCoords: [Self] {
        [
            self.toE,
            self.toSE,
            self.toSW,
            self.toW,
            self.toNW,
            self.toNE
        ]
    }
}

protocol Targettable: Identifiable {
    var id: UUID { get }
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

protocol Actionable {
    func perform(by source: Pawn, on targets: [Pawn]?) -> Void
}

enum Action: Actionable  {
    case attack(Attack, for: Quantity)
    case bolster(for: Quantity)
    case heal(for: Quantity)
    case buff(Buff)
    case debuff(Debuff)
    case movement(for: Quantity?)

    func perform(by source: Pawn, on targets: [Pawn]? = []) {
        switch self {
            case let .attack(type, quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                }

                targets?.forEach { $0.hp -= Int(amt) }

            case let .movement(quantity):
                let amt = switch quantity {
                case let .constant(num): num
                case let .random(dice): dice.map { $0.roll().reduce(0, +) }.reduce(0, +)
                case .none: UInt(1)
                }

                targets?.forEach { $0.moves += amt }

            default:
                return
        }
    }

    enum Quantity {
        case constant(UInt)
        case random([Die])
    }

    // attack
    enum Attack {
        case physical(PhysicalAttack)
        case metaphysical(MetaphysicalAttack)
    }
    
    enum PhysicalAttack {
        case slash
        case bludgeon
        case pierce
    }

    enum MetaphysicalAttack {
        case arcane
        case fire
        case cold
        case shock
        case poison
        case lux
        case dark
        // idk, i just started listing things
    }
    // buff
    enum Buff {}

    // debuff
    enum Debuff {}
}

enum Die {
    case d0
    case d2
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case d100

    func roll(_ n: UInt = 1) -> [UInt] {
        var rolls: [UInt] = Array<UInt>()
        var fn: () -> UInt

        switch self {
            case .d0:
                fn = { 0 }
            case .d2:
                fn = { UInt.random(in: 0...1) }
            case .d4:
                fn = { UInt.random(in: 1...4) }
            case .d6:
                fn = { UInt.random(in: 1...6) }
            case .d8:
                fn = { UInt.random(in: 1...8) }
            case .d10:
                fn = { UInt.random(in: 0...9) }
            case .d12:
                fn = { UInt.random(in: 1...12) }
            case .d20:
                fn = { UInt.random(in: 1...20) }
            case .d100:
                fn = { UInt.random(in: 0...99) }
        }

        for _ in 1...n {
            let result = fn()
            rolls.append(result)
        }

        return rolls
    }

    func sumRoll(_ n: UInt) -> UInt {
        return self.roll(n).reduce(0) { $0 + $1 }
    }
}
