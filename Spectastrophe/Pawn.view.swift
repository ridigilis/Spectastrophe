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
            if pawn.type == .enemy && pawn.hp > 0 {
                ProgressView(value: Float(pawn.hp), total: Float(pawn.maxHp))
                    .tint(.red)
                    .border(Color.black)
                    .frame(width: 48)
                    .scaleEffect(y: 2)
            }
            switch pawn.type {
            case .player: Image("pawn-player").resizable().scaledToFit()
            case .enemy: Image("pawn-enemy").resizable().scaledToFit()
            }
        }
        .offset(y: -40)
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
            Avatar.rotationEffect(.degrees(90)).offset(x: -40, y: -12)
        } else {
            Avatar
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
