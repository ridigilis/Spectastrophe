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
		self.hp = hp ?? player?.hp ?? 0
		self.deck = deck ?? player?.deck ?? Deck()
	}
}

struct Deck {
	let drawPile: [Card]
	let hand: [Card]
	let playArea: [Card]
	let discardPile: [Card]
	let exhaustPile: [Card]

	init(_ deck: Deck? = nil, drawPile: [Card]? = nil, hand: [Card]? = nil, playArea: [Card]? = nil, discardPile: [Card]? = nil, exhaustPile: [Card]? = nil) {
        self.drawPile = drawPile ?? deck?.drawPile ?? []
        self.hand = hand ?? deck?.hand ?? []
        self.playArea = playArea ?? deck?.playArea ?? []
        self.discardPile = discardPile ?? deck?.discardPile ?? []
        self.exhaustPile = exhaustPile ?? deck?.exhaustPile ?? []
	}

    private func drawCards(_ amt: UInt) -> Self {
        Self(self,
             drawPile: self.drawPile.enumerated().filter { $0.offset > amt }.map { $0.element },
             hand: self.hand + self.drawPile.enumerated().filter { $0.offset <= amt }.map { $0.element }
        )
    }

    func draw() -> Self {
        self.drawCards(1)
    }

    func play(_ card: Card) -> Self {
        Self(self,
             hand: self.hand.filter { $0 != card },
             playArea: self.playArea + [card]
        )

    }


}
struct Card: Equatable {

}

struct OverWorld {}
struct Encounter {}
struct Tile {}

protocol Targettable {
	var hp: Int { get }
}

protocol HasDeck {
	var deck: Deck { get }
}
