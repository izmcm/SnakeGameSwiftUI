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

enum SnakeViewInput {
  case startGame
  case resetGame
  case updateSnakePosition
  case updateSnakeDirection(gesture: DragGesture.Value, initialGesturePosition: CGPoint)
}

struct SnakeView: View {
  @ObservedObject private var viewModel = SnakeViewModel()
  
  @State private var gestureFlag: Bool = true
  @State private var initialGesturePosition: CGPoint = .zero

  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.white
        
      if /*@START_MENU_TOKEN@*/SNAKE IS DEAD/*@END_MENU_TOKEN@*/ {
        ResetGameButton(viewModel: self.viewModel)
      } else {
        ZStack {
          ForEach(0..</*@START_MENU_TOKEN@*/SNAKE BODY SIZE/*@END_MENU_TOKEN@*/, id: \.self) { index in
            Rectangle()
              .frame(width: viewModel.state.snake.squareSize,
                     height: viewModel.state.snake.squareSize)
              .position(/*@START_MENU_TOKEN@*/SNAKE BODY POSITIONS/*@END_MENU_TOKEN@*/)
          }
          
          Rectangle()
            .frame(width: viewModel.state.snake.squareSize,
                   height: viewModel.state.snake.squareSize)
            .foregroundColor(.red)
            .position(/*@START_MENU_TOKEN@*/FOOD POSITION/*@END_MENU_TOKEN@*/)
        }
      }
    }
    .onAppear {
      self.viewModel.trigger(/*@START_MENU_TOKEN@*/START GAME/*@END_MENU_TOKEN@*/)
    }
    .gesture(DragGesture().onChanged { gesture in
      if self.gestureFlag {
        self.initialGesturePosition = gesture.location
        self.gestureFlag.toggle()
      }
    }
    .onEnded { gesture in
      self.gestureFlag.toggle()
      self.viewModel.trigger(/*@START_MENU_TOKEN@*/UPDATE DIRECTION/*@END_MENU_TOKEN@*/)
    })
    .onReceive(timer) { (_) in
      if !self.viewModel.state.snake.isDead {
        self.viewModel.trigger(/*@START_MENU_TOKEN@*/UPDATE POSITION/*@END_MENU_TOKEN@*/)
      }
    }
  }
}

struct SnakeView_Previews: PreviewProvider {
  static var previews: some View {
    SnakeView()
  }
}
