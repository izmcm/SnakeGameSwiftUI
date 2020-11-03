//
//  SnakeViewModel+Extension.swift
//  SnakeGame
//
//  Created by im on 27/10/20.
//  Copyright © 2020 IzabellaMelo. All rights reserved.
//

import SwiftUI

extension SnakeViewModel {
  
  func generateFoodPosition() {
    self.state.foodPosition = randomPoint()
  }
  
  func generateSnakeInitialPosition() {
    self.state.snake.bodyPositions[0] = randomPoint()
  }

  func changeDirection(to input: Directions) {
    switch state.snake.direction {
    case .up:
      if input != .down {
        state.snake.direction = input
      }
    case .down:
      if input != .up {
        state.snake.direction = input
      }
    case .right:
      if input != .left {
        state.snake.direction = input
      }
    case .left:
      if input != .right {
        state.snake.direction = input
      }
    }
  }
  
  func randomPoint() -> CGPoint {
    let rows = Int(maxX/self.state.snake.squareSize)
    let cols = Int(maxY/self.state.snake.squareSize)
    
    let randomX = Int.random(in: 1..<rows)*Int(self.state.snake.squareSize)
    let randomY = Int.random(in: 1..<cols)*Int(self.state.snake.squareSize)
    
    return CGPoint(x: randomX, y: randomY)
  }
  
  func checkIfIsDead() {
    if state.snake.bodyPositions[0].x < minX || state.snake.bodyPositions[0].x > maxX && !state.snake.isDead {
      state.snake.isDead = true
    } else if state.snake.bodyPositions[0].y < minY || state.snake.bodyPositions[0].y > maxY  && !state.snake.isDead {
      state.snake.isDead = true
    }
  }
  
  func checkIfEatFood() {
    if state.snake.bodyPositions[0] == state.foodPosition {
      state.snake.bodyPositions.append(.zero)
      generateFoodPosition()
    }
  }
}
