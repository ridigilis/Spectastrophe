//
//  PawnView.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import SwiftUI

struct PawnView: View {
    @ObservedObject var pawn: Pawn
    @State private var showDamage = false
    @State private var prevDamageTaken = 0
    
    @ViewBuilder var Avatar: some View {
        VStack {
            ProgressView(value: Float(pawn.hp), total: Float(pawn.maxHp))
            Image(systemName: "person.fill").resizable().scaledToFill()
        }
        .rotation3DEffect(.degrees(-22.5), axis: (x: 1, y: 0, z: 0))
        .frame(width: 40, height: 80, alignment: .center)
        .offset(y: -12)
        .onChange(of: pawn.hp) { old, new in
            prevDamageTaken = old - new
            withAnimation {
                showDamage.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    showDamage.toggle()
                }
            }
        }
        .overlay(alignment: .top) {
            if showDamage {
                Text(String(prevDamageTaken))
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.red)
                    .offset(y: -48)
                    .transition(.push(from: .bottom))
            }
        }
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
    let player = Pawn(.player, maxHp: 120)
    let enemy = Pawn(.enemy, maxHp: 60)
    return HStack {
        PawnView(pawn: player)
        PawnView(pawn: enemy)
        PawnView(pawn: Pawn())
    }
}
