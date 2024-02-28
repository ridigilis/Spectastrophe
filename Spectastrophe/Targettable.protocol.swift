//
//  Targettable.protocol.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/3/24.
//

import Foundation

protocol Targettable: Identifiable {
    var id: UUID { get }
    var hp: Int { get set }
    var maxHp: Int { get set }
    var coords: Coords? { get set }
}
