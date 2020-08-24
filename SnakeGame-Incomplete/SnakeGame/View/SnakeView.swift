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
  var initialGesturePosition: CGPoint
}

struct SnakeView: View {
  @State private var gameIsStarted: Bool = true

  let timer = Timer.publish(every: 0.1, on: .main,
                            in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.white
      
      if self.viewModel.state.snake.isDead {
        VStack {
          Text("Game Over").padding()
          Button(action: {
            // resetar jogo
          }) {
            Text("Play again!")
          }
        }
      } else {
        ZStack {
          ForEach(0..<self.viewModel.state.snake.bodyPositions.count,
                  id: \.self) { index in
            Rectangle()
              .frame(width: self.viewModel.state.snake.size,
                     height: self.viewModel.state.snake.size)
              .position(self.viewModel.state.snake.bodyPositions[index])
          }
          
          Rectangle()
            .frame(width: self.viewModel.state.snake.size,
                   height: self.viewModel.state.snake.size)
            .position(self.viewModel.state.foodPosition)
            .foregroundColor(.red)
        }
      }
    }.onAppear {
      self.viewModel.generateSnakeInitialPosition()
      self.viewModel.generateFoodPosition()
    }
    .gesture(DragGesture().onChanged { gesture in
      if self.gameIsStarted {
        self.viewModel.state.initialGesturePosition = gesture.location
        self.gameIsStarted.toggle()
      }
    }
    .onEnded { gesture in
      self.viewModel.updateDirection(gesture)
      self.gameIsStarted.toggle()
    })
    .onReceive(timer) { (_) in
      if !self.viewModel.state.snake.isDead {
        self.viewModel.updateSnakePosition()
      }
    }
  }
}

struct SnakeView_Previews: PreviewProvider {
  static var previews: some View {
    var view = SnakeView()
    return view
  }
}
