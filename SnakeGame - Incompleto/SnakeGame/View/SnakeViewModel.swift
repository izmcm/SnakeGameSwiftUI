//
//  SnakeViewModel.swift
//  SnakeGame
//
//  Created by im on 20/08/20.
//  Copyright © 2020 IzabellaMelo. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class SnakeViewModel: ObservableObject {
  let minX = UIScreen.main.bounds.minX
  let maxX = UIScreen.main.bounds.maxX
  let minY = UIScreen.main.bounds.minY
  let maxY = UIScreen.main.bounds.maxY
  
  @Published var state: SnakeViewState
    
  init() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], squareSize: 10, isDead: false)
    self.state = SnakeViewState(snake: snakeModel, foodPosition: .zero)
  }
  
  func trigger(_ input: SnakeViewInput) {
    switch input {
    case .startGame:
      self.startGame()
    case .resetGame:
      self.resetGame()
    case .updateSnakeDirection(let gesture, let initialGesturePosition):
      self.updateDirection(gesture: gesture, initialGesturePosition: initialGesturePosition)
    case .updateSnakePosition:
      self.updateSnakePosition()
    }
  }
}
