//
//  CardView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct CardView: View {
    var card: any Card
    @ObservedObject var player: Pawn

    @State private var fill = Color(.white)

    @State private var dragAmount = CGSize.zero

    var body: some View {
        VStack {
            Text(card.title)
                .frame(alignment: .topLeading)
                .bold()
                .padding(.top).padding(.top)

            Spacer()

            Text(card.description)
                .font(.footnote)
                .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: 180, maxHeight: 240)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(fill)
                .strokeBorder(.brown, lineWidth: 12)
        }
        .shadow(radius: 12)
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    if player.turnToPlay {
                        dragAmount = $0.translation
                        if dragAmount.height < -200 {
                            fill = Color.teal
                        } else {
                            fill = Color.white
                        }
                    }
                }
                .onEnded { _ in
                    if player.turnToPlay && player.isMovingWith == nil && player.isAttackingWith == nil {
                        if dragAmount.height < -200 {
                            switch card.action {
                                case .attack: player.isAttackingWith = card as? ActionCard
                                case .movement: player.isMovingWith = card as? ActionCard
                                case .equip: card.action.perform(by: player, on: [player], using: card as? GearCard)
                                default: return
                            }
                            player.deck.playFromHand(card)
                        }

                        fill = Color.white
                        dragAmount = .zero
                    }
                }
        )
        .animation(.bouncy, value: dragAmount)
    }
}

#Preview {
    let card = ActionCard(action: .attack(.physical(.bludgeon), for: .constant(1)))
    let player = Pawn(.player)
    
    return CardView(card: card, player: player)
}
