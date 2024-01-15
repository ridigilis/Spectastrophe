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
        Image(systemName: "person").resizable().scaledToFit()
    }

    var body: some View {
        if pawn.hp <= 0 {
            Text("☠️")
        } else {
            switch pawn.type {
                case .player: Avatar
                case .enemy: Avatar.foregroundStyle(Color.red)
            }
        }
    }
}

#Preview {
    let pawn = Pawn()
    return PawnView(pawn: pawn)
}
