//
//  HandView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct HandView: View {
    @ObservedObject var deck: Deck
    @ObservedObject var player: Pawn

    var body: some View {
        HStack {
            ForEach(deck.hand) { card in
                CardView(card: card, player: player)
            }
        }
    }
}

#Preview {
    HandView()
}
