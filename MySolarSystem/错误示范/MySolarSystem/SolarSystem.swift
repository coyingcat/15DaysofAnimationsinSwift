/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct SolarSystem: View {
  var moons: [Moon] { planet.moons }
  let planet: Planet
  @State private var animationFlag = false

  var body: some View {
    GeometryReader { geometry in
      self.makeSystem(geometry)
    }
  }

  func moonPath(planetSize: CGFloat, radiusIncrement: CGFloat, index: CGFloat) -> some View {
    return Circle()
      .stroke(Color.gray)
      .frame(width: planetSize + radiusIncrement * index,
             height: planetSize + radiusIncrement * index)
  }

  func moon(planetSize: CGFloat,
            moonSize: CGFloat,
            radiusIncrement: CGFloat,
            index: CGFloat) -> some View {
    return Circle()
      .fill(Color.orange)
      .frame(width: moonSize, height: moonSize)
  }

  func makeSystem(_ geometry: GeometryProxy) -> some View {
    let planetSize = geometry.size.height * 0.25
    let moonSize = geometry.size.height * 0.1
    let radiusIncrement = (geometry.size.height - planetSize - moonSize) / CGFloat(moons.count)
    let range = 1 ... moons.count
    return
      ZStack {
        Circle()
          .fill(planet.drawColor)
          .frame(width: planetSize, height: planetSize, alignment: .center)

        ForEach(range, id: \.self) { index in
          // orbit paths
          self.moonPath(planetSize: planetSize, radiusIncrement: radiusIncrement, index: CGFloat(index))
        }
        ForEach(range, id: \.self) { index in
          // individual "moon" circles
          self.moon(planetSize: planetSize, moonSize: moonSize, radiusIncrement: radiusIncrement, index: CGFloat(index))
              .modifier(self.makeOrbitEffect(
                diameter: planetSize + radiusIncrement * CGFloat(index)
              ))
              .animation(Animation
                .linear(duration: Double.random(in: 10 ... 100))
                .repeatForever(autoreverses: false)
              )
        }
    }
    .onAppear {
      self.animationFlag.toggle()
    }
  }

  func animation(index: Double) -> Animation {
    return Animation.spring(response: 0.55, dampingFraction: 0.45, blendDuration: 0)
      .speed(2)
      .delay(0.075 * index)
  }

  func makeOrbitEffect(diameter: CGFloat) -> some GeometryEffect {
    return OrbitEffect(angle: self.animationFlag ? 2 * .pi : 0,
                       radius: diameter / 2.0)
  }
}

struct OrbitEffect: GeometryEffect {
  let initialAngle = CGFloat.random(in: 0 ..< 2 * .pi)

  var angle: CGFloat = 0
  let radius: CGFloat

  var animatableData: CGFloat {
    get { return angle }
    set { angle = newValue }
  }

  func effectValue(size: CGSize) -> ProjectionTransform {
    let pt = CGPoint(x: cos(angle + initialAngle) * radius,
                     y: sin(angle + initialAngle) * radius)
    let translation = CGAffineTransform(translationX: pt.x, y: pt.y)
    return ProjectionTransform(translation)
  }
}

#if DEBUG
struct SolarSystem_Previews: PreviewProvider {
  static var previews: some View {
    SolarSystem(planet: planets[5])
      .frame(width: 320, height: 240)
  }
}
#endif
