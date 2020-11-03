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

class SnakeViewModel {
  let minX = UIScreen.main.bounds.minX
  let maxX = UIScreen.main.bounds.maxX
  let minY = UIScreen.main.bounds.minY
  let maxY = UIScreen.main.bounds.maxY
  
  init() {
//    state = SnakeViewState(snake: SnakeModel(direction: .down, bodyPositions: [.zero],
//                                             squareSize: 10, isDead: false),
//                           foodPosition: .zero)
  }
  
  func trigger(_ input: SnakeViewInput) {

  }
  
  private func startGame() {
    self.generateSnakeInitialPosition()
    self.generateFoodPosition()
  }
  
  private func resetGame() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], squareSize: 10, isDead: false)
    self.state = SnakeViewState(snake: snakeModel, foodPosition: .zero)
    generateSnakeInitialPosition()
    generateFoodPosition()
  }
  
  private func updateDirection(gesture: DragGesture.Value, initialGesturePosition: CGPoint) {
    let xDist =  abs(gesture.location.x - initialGesturePosition.x)
    let yDist =  abs(gesture.location.y - initialGesturePosition.y)
    
    if initialGesturePosition.y < gesture.location.y && yDist > xDist {
      self.changeDirection(to: .down)
    } else if initialGesturePosition.y > gesture.location.y && yDist > xDist {
      self.changeDirection(to: .up)
    } else if initialGesturePosition.x > gesture.location.x && yDist < xDist {
      self.changeDirection(to: .right)
    } else if initialGesturePosition.x < gesture.location.x && yDist < xDist {
      self.changeDirection(to: .left)
    }
  }
  
  private func updateSnakePosition() {
    checkIfIsDead()
    
    var previous = state.snake.bodyPositions[0]
    switch state.snake.direction {
    case .down:
      state.snake.bodyPositions[0].y += CGFloat(state.snake.squareSize)
    case .up:
      state.snake.bodyPositions[0].y -= CGFloat(state.snake.squareSize)
    case .left:
      state.snake.bodyPositions[0].x += CGFloat(state.snake.squareSize)
    case .right:
      state.snake.bodyPositions[0].x -= CGFloat(state.snake.squareSize)
    }
    
    checkIfEatFood()
    
    for index in 1..<state.snake.bodyPositions.count {
      let current = state.snake.bodyPositions[index]
      state.snake.bodyPositions[index] = previous
      previous = current
    }
  }
}
