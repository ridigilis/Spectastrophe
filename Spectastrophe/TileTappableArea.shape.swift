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
        
        path.move(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.09))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.98, y: (rect.maxY) / 3.2))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.98, y: ((rect.maxY) / 3.3) * 2))
        
        path.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.826))
        
        path.addLine(to: CGPoint(x: rect.maxX * 0.02, y: ((rect.maxY) / 3.3)*2))
        
        path.addLine(to: CGPoint(x: rect.maxX  * 0.02, y: ((rect.maxY) / 3.2)))
        
        path.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY * 0.09))
        
        path.closeSubpath()

        return path
    }
}

#Preview {
    Image("tile-grassy").overlay {
        TileTappableArea()
            .fill(Color.clear)
            .stroke(Color.black, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
            
    }
    .onTapGesture {
        print("tapped")
    }
}
