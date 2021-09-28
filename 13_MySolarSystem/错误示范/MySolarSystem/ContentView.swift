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

extension AnyTransition {
  static var customTransition: AnyTransition {
    let insertion = AnyTransition.move(edge: .top)
      .combined(with: .scale(scale: 0.2, anchor: .topTrailing))
      .combined(with: .opacity)
    let removal = AnyTransition.move(edge: .top)
    return .asymmetric(insertion: insertion, removal: removal)
  }
}

struct ContentView: View {
  @State var showMoon: String? = nil
  let moonAnimation = Animation.default

  func toggleMoons(_ name: String) -> Bool {
    return name == showMoon
  }

  var body: some View {
    List(planets) { planet in
      self.makePlanetRow(planet: planet)
    }
  }

  func makePlanetRow(planet: Planet) -> some View {
    VStack {
      HStack {
        Image(planet.name)
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(height: 60)
        Text(planet.name)
        Spacer()
        if planet.hasMoons {
          Button(action: {
            withAnimation(.easeInOut) {
              self.showMoon = self.toggleMoons(planet.name) ? nil : planet.name
            }
          }) {
            Image(systemName: "moon.circle.fill")
              .rotationEffect(.degrees(self.toggleMoons(planet.name) ? -50 : 0))
              .animation(nil)
              .scaleEffect(self.toggleMoons(planet.name) ? 2 : 1)
              .animation(moonAnimation)
          }
        }
      }
      if self.toggleMoons(planet.name) {
        MoonList(planet: planet)
          .transition(.customTransition)
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
