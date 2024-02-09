//
//  TileTappableArea.shape.swift
//  Spectastrophe
//
//  Created by Ricky David Groner II on 2/9/24.
//

import SwiftUI

struct TileTappableArea: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.025))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.975, y: (rect.maxY) / 3.3))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.975, y: ((rect.maxY) / 3.5) * 2))
        
        path.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.85))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.025, y: ((rect.maxY) / 3.5)*2))
        
        path.addLine(to: CGPoint(x: rect.maxX  * 0.025, y: ((rect.maxY) / 3.3)))
        
        path.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.025))
        
        path.closeSubpath()

        return path
    }
}

#Preview {
    TileTappableArea().onTapGesture { print("tapped")}
}
