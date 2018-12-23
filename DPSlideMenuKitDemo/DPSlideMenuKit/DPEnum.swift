//
//  DPEnum.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import Foundation

public enum DPDrawerControllerState: Int {
  
  case closed = 0
  case leftOpen
  case rightOpen
  case leftClosing
  case leftOpening
  case rightClosing
  case rightOpening

  var description: String {
    switch self {
    case .closed:
      return "closed"
    case .leftOpen:
      return "left open"
    case .rightOpen:
      return "right open"
    case .leftClosing:
      return "left closing"
    case .leftOpening:
      return "left opening"
    case .rightClosing:
      return "right closing"
    case .rightOpening:
      return "right opening"
    }
  }
  
}

public enum DPEmbedViewControllerPositionState: Int {
  
  case left = 0
  case right
  
  var description: String {
    switch self {
    case .left:
      return "left"
    case .right:
      return "right"
    }
  }
  
}
