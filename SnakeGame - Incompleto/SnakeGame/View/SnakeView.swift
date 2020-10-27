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
  @ObservedObject var viewModel = SnakeViewModel()
  
  @State private var gestureFlag: Bool = true
  @State private var initialGesturePosition: CGPoint = .zero

  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.white
      
      if self.viewModel.state.snake.isDead {
        ResetGameButton(viewModel: self.viewModel)
      } else {
        ZStack {
          ForEach(0..<self.viewModel.state.snake.bodyPositions.count, id: \.self) { index in
            Rectangle()
              .frame(width: self.viewModel.state.snake.squareSize,
                     height: self.viewModel.state.snake.squareSize)
              .position(self.viewModel.state.snake.bodyPositions[index])
              #warning("pegar posição de cada ponto do corpo da cobra")
          }
          
          Rectangle()
            .frame(width: self.viewModel.state.snake.squareSize,
                   height: self.viewModel.state.snake.squareSize)
            .foregroundColor(.red)
            .position(self.viewModel.state.foodPosition)
            #warning("pegar posição da comida")
        }
      }
    }
    .onAppear {
      #warning("começar jogo")
      self.viewModel.trigger(.startGame)
    }
    .gesture(DragGesture().onChanged { gesture in
      if self.gestureFlag {
        self.initialGesturePosition = gesture.location
        self.gestureFlag.toggle()
      }
    }
    .onEnded { gesture in
      self.gestureFlag.toggle()
      self.viewModel.trigger(.updateSnakeDirection(gesture: gesture, initialGesturePosition: self.initialGesturePosition))
      #warning("atualizar direção da cobra de acordo com o gesto do usuário")
    })
    .onReceive(timer) { (_) in
      if !self.viewModel.state.snake.isDead {
        #warning("atualizar posição da cobra com o tempo")
        self.viewModel.trigger(.updateSnakePosition)
      }
    }
  }
}

struct SnakeView_Previews: PreviewProvider {
  static var previews: some View {
    SnakeView(viewModel: SnakeViewModel())
  }
}
