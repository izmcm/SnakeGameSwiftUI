//
//  SnakeModel.swift
//  SnakeGame
//
//  Created by im on 20/08/20.
//  Copyright © 2020 IzabellaMelo. All rights reserved.
//

import Foundation
import UIKit

enum Directions {
  case up
  case down
  case right
  case left
}

struct SnakeModel {
  var direction: Directions
  var bodyPositions: [CGPoint]
  var squareSize: CGFloat
  var isDead: Bool
}
