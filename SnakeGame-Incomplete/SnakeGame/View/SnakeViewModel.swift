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

protocol SnakeViewModelProtocol {
  var state: SnakeViewState { get set }
  func updateDirection(_ gesture: DragGesture.Value)
  func generateFoodPosition()
  func generateSnakeInitialPosition()
  func updateSnakePosition()
  func resetGame()
}

class SnakeViewModel: SnakeViewModelProtocol {  
  let minX = UIScreen.main.bounds.minX
  let maxX = UIScreen.main.bounds.maxX
  let minY = UIScreen.main.bounds.minY
  let maxY = UIScreen.main.bounds.maxY
  
  init() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], size: 10, isDead: false)
    self.state = SnakeViewState(snake: snakeModel, foodPosition: .zero, initialGesturePosition: .zero)
  }
  
  func updateDirection(_ gesture: DragGesture.Value) {
    let xDist =  abs(gesture.location.x - self.state.initialGesturePosition.x)
    let yDist =  abs(gesture.location.y - self.state.initialGesturePosition.y)
    
    if self.state.initialGesturePosition.y < gesture.location.y && yDist > xDist {
      self.changeDirection(to: .down)
    } else if self.state.initialGesturePosition.y > gesture.location.y && yDist > xDist {
      self.changeDirection(to: .up)
    } else if self.state.initialGesturePosition.x > gesture.location.x && yDist < xDist {
      self.changeDirection(to: .right)
    } else if self.state.initialGesturePosition.x < gesture.location.x && yDist < xDist {
      self.changeDirection(to: .left)
    }
  }
  
  func generateFoodPosition() {
    self.state.foodPosition = randomPoint()
  }
  
  func generateSnakeInitialPosition() {
    self.state.snake.bodyPositions[0] = randomPoint()
  }
  
  func updateSnakePosition() {
    checkIfIsDead()
    
    var previous = state.snake.bodyPositions[0]
    switch state.snake.direction {
    case .down:
      state.snake.bodyPositions[0].y += CGFloat(state.snake.size)
    case .up:
      state.snake.bodyPositions[0].y -= CGFloat(state.snake.size)
    case .left:
      state.snake.bodyPositions[0].x += CGFloat(state.snake.size)
    case .right:
      state.snake.bodyPositions[0].x -= CGFloat(state.snake.size)
    }
    
    checkIfEatFood()
    
    for index in 1..<state.snake.bodyPositions.count {
      let current = state.snake.bodyPositions[index]
      state.snake.bodyPositions[index] = previous
      previous = current
    }
  }
  
  func resetGame() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], size: 10, isDead: false)
    self.state = SnakeViewState(snake: snakeModel, foodPosition: .zero, initialGesturePosition: .zero)
    generateSnakeInitialPosition()
    generateFoodPosition()
  }
  
  // MARK: HELP FUNCTIONS
  private func changeDirection(to input: Directions) {
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
  
  private func randomPoint() -> CGPoint {
    let rows = Int(maxX/self.state.snake.size)
    let cols = Int(maxY/self.state.snake.size)
    
    let randomX = Int.random(in: 1..<rows)*Int(self.state.snake.size)
    let randomY = Int.random(in: 1..<cols)*Int(self.state.snake.size)
    
    return CGPoint(x: randomX, y: randomY)
  }
  
  private func checkIfIsDead() {
    if state.snake.bodyPositions[0].x < minX || state.snake.bodyPositions[0].x > maxX && !state.snake.isDead {
      state.snake.isDead = true
    } else if state.snake.bodyPositions[0].y < minY || state.snake.bodyPositions[0].y > maxY  && !state.snake.isDead {
      state.snake.isDead = true
    }
  }
  
  private func checkIfEatFood() {
    if state.snake.bodyPositions[0] == state.foodPosition {
      state.snake.bodyPositions.append(.zero)
      generateFoodPosition()
    }
  }
}
