//
//  ResetGameButton.swift
//  SnakeGame
//
//  Created by im on 27/10/20.
//  Copyright © 2020 IzabellaMelo. All rights reserved.
//

import SwiftUI

struct ResetGameButton: View {
  @ObservedObject var viewModel: SnakeViewModel
  
  var body: some View {
    VStack {
      Text("Game Over").padding()
      
      Button(action: {
        self.viewModel.trigger(.resetGame)
      }) {
        Text("Play again!")
      }
    }
  }
}

struct ResetGameButton_Previews: PreviewProvider {
  static var previews: some View {
    ResetGameButton(viewModel: SnakeViewModel())
  }
}
