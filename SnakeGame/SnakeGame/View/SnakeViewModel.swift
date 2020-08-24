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
  var viewState: SnakeViewState { get set }
  func updateDirection(_ gesture: DragGesture.Value)
  func generateFoodPosition()
  func generateSnakeInitialPosition()
  func updateSnakePosition()
  func resetGame()
}

final class SnakeViewModel: ObservableObject, SnakeViewModelProtocol {
  @Published var viewState: SnakeViewState

  let minX = UIScreen.main.bounds.minX
  let maxX = UIScreen.main.bounds.maxX
  let minY = UIScreen.main.bounds.minY
  let maxY = UIScreen.main.bounds.maxY
    
  init() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], size: 10, isDead: false)
    self.viewState = SnakeViewState(snake: snakeModel, foodPosition: .zero, initialGesturePosition: .zero)
  }
  
  func updateDirection(_ gesture: DragGesture.Value) {
    let xDist =  abs(gesture.location.x - self.viewState.initialGesturePosition.x)
    let yDist =  abs(gesture.location.y - self.viewState.initialGesturePosition.y)
    
    if self.viewState.initialGesturePosition.y < gesture.location.y && yDist > xDist {
      self.changeDirection(to: .down)
    } else if self.viewState.initialGesturePosition.y > gesture.location.y && yDist > xDist {
      self.changeDirection(to: .up)
    } else if self.viewState.initialGesturePosition.x > gesture.location.x && yDist < xDist {
      self.changeDirection(to: .right)
    } else if self.viewState.initialGesturePosition.x < gesture.location.x && yDist < xDist {
      self.changeDirection(to: .left)
    }
  }
  
  func generateFoodPosition() {
    self.viewState.foodPosition = randomPoint()
  }
  
  func generateSnakeInitialPosition() {
    self.viewState.snake.bodyPositions[0] = randomPoint()
  }
  
  func updateSnakePosition() {
    checkIfIsDead()
    
    var previous = viewState.snake.bodyPositions[0]
    switch viewState.snake.direction {
    case .down:
      viewState.snake.bodyPositions[0].y += CGFloat(viewState.snake.size)
    case .up:
      viewState.snake.bodyPositions[0].y -= CGFloat(viewState.snake.size)
    case .left:
      viewState.snake.bodyPositions[0].x += CGFloat(viewState.snake.size)
    case .right:
      viewState.snake.bodyPositions[0].x -= CGFloat(viewState.snake.size)
    }
    
    checkIfEatFood()
    
    for index in 1..<viewState.snake.bodyPositions.count {
      let current = viewState.snake.bodyPositions[index]
      viewState.snake.bodyPositions[index] = previous
      previous = current
    }
  }
  
  func resetGame() {
    let snakeModel = SnakeModel(direction: .left, bodyPositions: [.zero], size: 10, isDead: false)
    self.viewState = SnakeViewState(snake: snakeModel, foodPosition: .zero, initialGesturePosition: .zero)
    generateSnakeInitialPosition()
    generateFoodPosition()
  }
  
  // MARK: HELP FUNCTIONS
  private func changeDirection(to input: Directions) {
    switch viewState.snake.direction {
    case .up:
      if input != .down {
        viewState.snake.direction = input
      }
    case .down:
      if input != .up {
        viewState.snake.direction = input
      }
    case .right:
      if input != .left {
        viewState.snake.direction = input
      }
    case .left:
      if input != .right {
        viewState.snake.direction = input
      }
    }
  }
  
  private func randomPoint() -> CGPoint {
    let rows = Int(maxX/self.viewState.snake.size)
    let cols = Int(maxY/self.viewState.snake.size)
    
    let randomX = Int.random(in: 1..<rows)*Int(self.viewState.snake.size)
    let randomY = Int.random(in: 1..<cols)*Int(self.viewState.snake.size)
    
    return CGPoint(x: randomX, y: randomY)
  }
  
  private func checkIfIsDead() {
    if viewState.snake.bodyPositions[0].x < minX || viewState.snake.bodyPositions[0].x > maxX && !viewState.snake.isDead {
      viewState.snake.isDead = true
    } else if viewState.snake.bodyPositions[0].y < minY || viewState.snake.bodyPositions[0].y > maxY  && !viewState.snake.isDead {
      viewState.snake.isDead = true
    }
  }
  
  private func checkIfEatFood() {
    if viewState.snake.bodyPositions[0] == viewState.foodPosition {
      viewState.snake.bodyPositions.append(.zero)
      generateFoodPosition()
    }
  }
}
