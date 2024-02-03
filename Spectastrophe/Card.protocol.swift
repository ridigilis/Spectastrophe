//
//  Card.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

protocol Card: Identifiable {
    var id: UUID { get }
    var parentId: UUID? { get }

    var action: Action { get }

    var title: String { get }
    var description: String { get }
}
