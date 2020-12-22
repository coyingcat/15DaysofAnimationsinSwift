//
//  Path.swift
//  555
//
//  Created by Jz D on 2020/12/22.
//

import Foundation

import SwiftUI


// MARK: - Example 9 - Follow Path
struct Example9: View {
    @State private var flag = false

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {

                // Draw the Infinity Shape
                InfinityShape().stroke(Color.purple, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [7, 7], dashPhase: 0))
                    .foregroundColor(.blue)
                    .frame(width: proxy.size.width, height: 300)

                // Animate movement of Image
                Image(systemName: "airplane").resizable().foregroundColor(Color.red)
                    .frame(width: 50, height: 50).offset(x: -25, y: -25)
                    .modifier(FollowEffect(pct: self.flag ? 1 : 0, path: InfinityShape.createInfinityPath(in: CGRect(x: 0, y: 0, width: proxy.size.width, height: 300)), rotate: true))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                            self.flag.toggle()
                        }
                    }

                }.frame(alignment: .topLeading)
        }
        .padding(20)
        .navigationBarTitle("Example 9")

    }
}

struct FollowEffect: GeometryEffect {
    var pct: CGFloat = 0
    let path: Path
    var rotate = true

    var animatableData: CGFloat {
        get { return pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        if !rotate {
            let pt = percentPoint(pct)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
        } else {
            // Calculate rotation angle, by calculating an imaginary line between two points
            // in the path: the current position (1) and a point very close behind in the path (2).
            let pt1 = percentPoint(pct)
            let pt2 = percentPoint(pct - 0.01)

            let a = pt2.x - pt1.x
            let b = pt2.y - pt1.y

            let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi

            let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: CGFloat(angle))

            return ProjectionTransform(transform)
        }
    }

    func percentPoint(_ percent: CGFloat) -> CGPoint {

        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > 0.999 ? CGFloat(1-0.001) : pct
        let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}

struct InfinityShape: Shape {
    func path(in rect: CGRect) -> Path {
        return InfinityShape.createInfinityPath(in: rect)
    }

    static func createInfinityPath(in rect: CGRect) -> Path {
        let height = rect.size.height
        let width = rect.size.width
        let heightFactor = height/4
        let widthFactor = width/4

        var path = Path()

        path.move(to: CGPoint(x:widthFactor, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor), control1: CGPoint(x:0, y: heightFactor * 3), control2: CGPoint(x:0, y: heightFactor))

        path.move(to: CGPoint(x:widthFactor, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3), control1: CGPoint(x:widthFactor * 2, y: heightFactor), control2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))

        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor), control1: CGPoint(x:widthFactor * 4 + 5, y: heightFactor * 3), control2: CGPoint(x:widthFactor * 4 + 5, y: heightFactor))

        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor * 3), control1: CGPoint(x:widthFactor * 2, y: heightFactor), control2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))

        return path
    }
}



extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
