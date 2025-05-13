//
//  StarShowerView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI

struct Star {
    var position: CGPoint
    var velocity: CGFloat
}

struct StarShowerView: View {
    @State private var stars: [Star] = []
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let screenSize = UIScreen.main.bounds.size
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        Canvas { context, size in
            for star in stars {
                let rect = CGRect(x: star.position.x, y: star.position.y, width: 2, height: 2)
                context.fill(Path(ellipseIn: rect), with: .color(.snow))
            }
        }
        .onAppear {
            for _ in 0..<100 {
                let newStar = Star(
                    position: CGPoint(x: CGFloat.random(in: 0...screenSize.width),
                                      y: CGFloat.random(in: 0...screenHeight)),
                    velocity: CGFloat.random(in: 2...5)
                )
                stars.append(newStar)
            }
        }
        .onReceive(timer) { _ in
            for i in 0..<stars.count {
                stars[i].position.y += stars[i].velocity
                if stars[i].position.y > screenHeight {
                    stars[i].position = CGPoint(x: CGFloat.random(in: 0...screenSize.width), y: 0)
                }
            }
        }
    }
}
#Preview {
    StarShowerView()
}
