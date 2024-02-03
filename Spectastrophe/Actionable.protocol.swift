//
//  Actionable.protocol.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/3/24.
//

import Foundation

protocol Actionable {
    func perform(by source: Pawn, on targets: [Pawn]?, using card: GearCard?) -> Void
}
