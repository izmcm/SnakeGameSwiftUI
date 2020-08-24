//
//  SnakeView.swift
//  SnakeGame
//
//  Created by im on 20/08/20.
//  Copyright © 2020 IzabellaMelo. All rights reserved.
//

import SwiftUI
import UIKit

struct SnakeViewState {
  var snake: SnakeModel
  var foodPosition: CGPoint
}

struct SnakeView: View {
  @ObservedObject var viewModel = SnakeViewModel()
  
  @State private var gameIsStarted: Bool = true
  @State private var initialGesturePosition: CGPoint = .zero
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.white
      
      if self.viewModel.viewState.snake.isDead {
        VStack {
          Text("Game Over").padding()
          Button(action: {
            self.viewModel.resetGame()
          }) {
            Text("Play again!")
          }
        }
      } else {
        ZStack {
          ForEach(0..<self.viewModel.viewState.snake.bodyPositions.count, id: \.self) { index in
            Rectangle()
              .frame(width: self.viewModel.viewState.snake.size,
                     height: self.viewModel.viewState.snake.size)
              .position(self.viewModel.viewState.snake.bodyPositions[index])
          }
          
          Rectangle()
            .frame(width: self.viewModel.viewState.snake.size,
                   height: self.viewModel.viewState.snake.size)
            .position(self.viewModel.viewState.foodPosition)
            .foregroundColor(.red)
        }
      }
    }.onAppear {
      self.viewModel.generateSnakeInitialPosition()
      self.viewModel.generateFoodPosition()
    }
    .gesture(DragGesture().onChanged { gesture in
      if self.gameIsStarted {
        self.initialGesturePosition = gesture.location
        self.gameIsStarted.toggle()
      }
    }
    .onEnded { gesture in
      let xDist =  abs(gesture.location.x - self.initialGesturePosition.x)
      let yDist =  abs(gesture.location.y - self.initialGesturePosition.y)
      
      if self.initialGesturePosition.y < gesture.location.y && yDist > xDist {
        self.viewModel.changeDirection(to: .down)
      } else if self.initialGesturePosition.y > gesture.location.y && yDist > xDist {
        self.viewModel.changeDirection(to: .up)
      } else if self.initialGesturePosition.x > gesture.location.x && yDist < xDist {
        self.viewModel.changeDirection(to: .right)
      } else if self.initialGesturePosition.x < gesture.location.x && yDist < xDist {
        self.viewModel.changeDirection(to: .left)
      }
      self.gameIsStarted.toggle()
    })
    .onReceive(timer) { (_) in
        self.viewModel.updateSnakePosition()
    }
  }
}

struct SnakeView_Previews: PreviewProvider {
  static var previews: some View {
    var view = SnakeView()
    view.viewModel = SnakeViewModel()
    return view
  }
}
