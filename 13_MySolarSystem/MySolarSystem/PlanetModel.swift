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

let planets = [
  Planet(name: "Mercury",
         moons: [],
         radius: 2_439.7,
         weight: 3.3011e23,
         gravity: 0.38,
         drawColor: .gray),
  Planet(name: "Venus",
         moons: [],
         radius: 6_051.8,
         weight: 4.8675e24,
         gravity: 0.904,
         drawColor: .yellow),
  Planet(name: "Earth",
         moons: [Moon(name: "Luna")],
         radius: 6_371,
         weight: 5.97237e24,
         gravity: 1,
         drawColor: .blue),
  Planet(name: "Mars",
         moons: [Moon(name: "Phobos"),
                 Moon(name: "Deimos")],
         radius: 3_389.5,
         weight: 6.4171e23,
         gravity: 0.3794,
         drawColor: .red),
  Planet(name: "Jupiter",
         moons: [Moon(name: "Ganymede"),
                 Moon(name: "Callisto"),
                 Moon(name: "Europa"),
                 Moon(name: "Amalthea"),
                 Moon(name: "Himalia"),
                 Moon(name: "Thebe"),
                 Moon(name: "Elara")],
         radius: 69_911,
         weight: 1.8982e27,
         gravity: 2.528,
         drawColor: .orange),
  Planet(name: "Saturn",
         moons: [Moon(name: "Titan"),
                 Moon(name: "Rhea"),
                 Moon(name: "Iapetus"),
                 Moon(name: "Dione"),
                 Moon(name: "Tethys"),
                 Moon(name: "Enceladus"),
                 Moon(name: "Mimas"),
                 Moon(name: "Hyperion"),
                 Moon(name: "Phoebe"),
                 Moon(name: "Janus")],
         radius: 60_268,
         weight: 5.6834e26,
         gravity: 1.065,
         drawColor: .yellow),
  Planet(name: "Uranus",
         moons: [Moon(name: "Titania"),
                 Moon(name: "Oberon"),
                 Moon(name: "Umbriel"),
                 Moon(name: "Ariel"),
                 Moon(name: "Miranda")],
         radius: 25_362,
         weight: 8.6810e25,
         gravity: 0.886,
         drawColor: .blue),
  Planet(name: "Neptune",
         moons: [Moon(name: "Triton"),
                 Moon(name: "Proteus"),
                 Moon(name: "Nereid"),
                 Moon(name: "Larissa"),
                 Moon(name: "Galatea")],
         radius: 24_622,
         weight: 1.02413e26,
         gravity: 1.14,
         drawColor: .blue)
]

struct Planet {
  let name: String
  let moons: [Moon]
  let radius: Double
  let weight: Double
  let gravity: Double
  let drawColor: Color

  var hasMoons: Bool { !moons.isEmpty }
}

extension Planet: Identifiable {
  var id: String {
    return name
  }
}

struct Moon {
  let name: String

  var image: UIImage {
    let path = Bundle.main.path(forResource: "\(name)".lowercased(), ofType: "jpg")
    if let path = path, let image = UIImage(contentsOfFile: path) {
      return image
    } else {
      return UIImage(contentsOfFile: Bundle.main.path(forResource: "titan".lowercased(), ofType: "jpg")!)!
    }
  }
}

extension Moon: Identifiable {
  var id: String {
    return name
  }
}

extension Moon: Equatable {}

