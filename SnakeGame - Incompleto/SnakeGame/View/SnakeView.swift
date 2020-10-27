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
  @State private var gestureFlag: Bool = true
  @State private var initialGesturePosition: CGPoint = .zero

  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.white
      
      if <#T##Bool#> {
        ResetGameButton(viewModel: self.viewModel)
      } else {
        ZStack {
          ForEach(0..<<#T##Int#>, id: \.self) { index in
            Rectangle()
              .frame(width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
              .position(<#T##CGPoint#>)
          }
          
          Rectangle()
            .frame(width: <#T##CGFloat?#>,
                   height: <#T##CGFloat?#>)
            .foregroundColor(.red)
            .position(<#T##CGPoint#>)
        }
      }
    }
    .onAppear {
      self.viewModel.trigger(<#T##SnakeViewInput#>)
    }
    .gesture(DragGesture().onChanged { gesture in
      if self.gestureFlag {
        self.initialGesturePosition = gesture.location
        self.gestureFlag.toggle()
      }
    }
    .onEnded { gesture in
      self.gestureFlag.toggle()
      self.viewModel.trigger(<#T##SnakeViewInput#>)
    })
    .onReceive(timer) { (_) in
      if !self.viewModel.state.snake.isDead {
        self.viewModel.trigger(<#T##SnakeViewInput#>)
      }
    }
  }
}

struct SnakeView_Previews: PreviewProvider {
  static var previews: some View {
    SnakeView()
  }
}
