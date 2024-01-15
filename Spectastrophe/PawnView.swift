//
//  PawnView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct PawnView: View {
    @ObservedObject var pawn: Pawn

    @ViewBuilder var Avatar: some View {
        Image(systemName: "person.fill").resizable().scaledToFit()
    }

    var body: some View {
        if pawn.hp <= 0 {
            Image(systemName: "person.slash.fill").resizable().scaledToFit().foregroundColor(.brown)
        } else {
            switch pawn.type {
                case .player: Avatar
                case .enemy: Avatar.foregroundStyle(Color.red)
            }
        }
    }
}

#Preview {
    let player = Pawn(.player, hp: 120)
    let enemy = Pawn(.enemy, hp: 60)
    return HStack {
        PawnView(pawn: player)
        PawnView(pawn: enemy)
        PawnView(pawn: Pawn())
    }
}
