//
//  Coords.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 1/14/24.
//

import Foundation

struct Coords: Hashable, Equatable, AdditiveArithmetic {
    static var zero: Coords = Coords(0,0)
    
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func walkStraight(toward direction: Direction, for steps: UInt) -> Self {
        switch direction {
        case .E: Self(self.x + Int(steps), self.y)
        case .SE: Self(self.x + Int(steps), self.y - Int(steps))
        case .SW: Self(self.x, self.y - Int(steps))
        case .W: Self(self.x - Int(steps), self.y)
        case .NW: Self(self.x - Int(steps), self.y + Int(steps))
        case .NE: Self(self.x, self.y + Int(steps))
        }
    }
    
    var toE: Self {
        walkStraight(toward: .E, for: 1)
    }
    var toSE: Self {
        walkStraight(toward: .SE, for: 1)
    }
    var toSW: Self {
        walkStraight(toward: .SW, for: 1)
    }
    var toW: Self {
        walkStraight(toward: .W, for: 1)
    }
    var toNW: Self {
        walkStraight(toward: .NW, for: 1)
    }
    var toNE: Self {
        walkStraight(toward: .NE, for: 1)
    }
    
    func isAdjacent(to coords: Self) -> Bool {
        switch coords {
        case self.toE: return true
        case self.toW: return true
        case self.toNE: return true
        case self.toNW: return true
        case self.toSE: return true
        case self.toSW: return true
        default: return false
        }
    }
    
    var allAdjacentCoords: [Self] {
        [
            self.toE,
            self.toSE,
            self.toSW,
            self.toW,
            self.toNW,
            self.toNE
        ]
    }
    
    func getBoundaryCoords(at radius: UInt = 1) -> [Self] {
        if radius == 0 {
            return [self]
        }
        
        if radius == 1 {
            return self.allAdjacentCoords
        }
        
        var coords: [Coords] = [self.walkStraight(toward: .E, for: radius)]
        var current: Coords = self.walkStraight(toward: .E, for: radius)
        let directions: [Direction] = [.SW, .W, .NW, .NE, .E, .SE]
        
        directions.forEach { direction in
            for _ in 1...radius {
                coords.append(current.walkStraight(toward: direction, for: 1))
                current = current.walkStraight(toward: direction, for: 1)
            }
        }
        
        return coords
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func +(lhs: Coords, rhs: Coords) -> Self {
        return Coords(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func -(lhs: Coords, rhs: Coords) -> Coords {
        return Coords(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    enum Direction {
        case E, SE, SW, W, NW, NE
    }
}
