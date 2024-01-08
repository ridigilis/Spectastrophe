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

@Observable
final class GameState {}

struct Player: Targettable, HasDeck {
	let hp: Int
	let deck: Deck

	init(_ player: Player? = nil, hp: Int? = nil, deck: Deck? = nil) {
		self.hp = hp ?? player?.hp ?? 0
		self.deck = deck ?? player?.deck ?? Deck()
	}
}
struct Enemy: Targettable, HasDeck {
	let hp: Int
	let deck: Deck

	init(_ enemy: Enemy? = nil, hp: Int? = nil, deck: Deck? = nil) {
		self.hp = hp ?? enemy?.hp ?? 0
		self.deck = deck ?? enemy?.deck ?? Deck()
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
        self.drawPile = drawPile ?? deck?.drawPile ?? DrawPile()
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
        internal let cards: [Card]

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
    let actions: [Action]

    // not sure if this is what I want this to be yet
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    enum CardType {
        case action, gear
    }
}

struct OverWorld {
    let board: Board

    struct OverWorldTile: Tile {}
}
struct Encounter {
    let board: Board

    struct EncounterTile: Tile {}
}
struct Board {
    let tiles: [Coords: Tile?]

    init(_ tiles: [Coords: Tile]? = nil, x: UInt = 0, y: UInt = 0) {
        if tiles == nil {
            var t: [Coords: Tile] = [:]
            for i in 0...x {
                for j in 0...y {
                    t[Coords(Int(i), Int(j))] = nil // will be a Tile when that gets fleshed out
                }
            }
            self.tiles = t
        } else {
            self.tiles = tiles!
        }
    }
}

protocol Tile {}

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
}

protocol HasDeck {
	var deck: Deck { get }
}

protocol Pile {
    var cards: [Card] { get }
}

protocol Action {
    var targets: [Targettable]? { get }
    var type: ActionType { get }
}

enum ActionType {
    case attack, defend, heal, buff, debuff, move
}
