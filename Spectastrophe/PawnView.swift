//
//  PawnView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct PawnView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PlayerView: View {
    @ObservedObject var player: Pawn
    var body: some View {
        if player.hp <= 0 {
            Text("☠️")
        } else {
            Image(systemName: "person").resizable().scaledToFit()
        }
    }
}

struct EnemyView: View {
    @ObservedObject var enemy: Pawn
    var body: some View {
        if enemy.hp <= 0 {
            Text("☠️")
        } else {
            Image(systemName: "person").resizable().scaledToFit().foregroundStyle(Color(.red))
        }
    }
}

#Preview {
    PawnView()
}
