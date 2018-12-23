//
//  DPConst.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

// MARK: Constant
let kDPDrawerButtonRect: CGRect = CGRect(x: 8.0, y: 25.0, width: 34.0, height: 34.0)
let kDPDrawerButtonRect_Bangs: CGRect = CGRect(x: 8.0, y: 45.0, width: 34.0, height: 34.0)

let kDPDrawerControllerDrawerWidthGapOffset: CGFloat = 60.0
let kDPDrawerControllerLeftViewInitialOffset: CGFloat = -60.0
let kDPGestureSensitivityValue: CGFloat = 80.0

let kDPDrawerControllerAnimationDuration: TimeInterval = 0.5
let kDPDrawerControllerOpeningAnimationSpringDamping: CGFloat = 1.0
let kDPDrawerControllerOpeningAnimationSpringInitialVelocity: CGFloat = 0.1
let kDPDrawerControllerClosingAnimationSpringDamping: CGFloat = 1.0
let kDPDrawerControllerClosingAnimationSpringInitialVelocity: CGFloat = 0.5
let kDPPageControlHeight: CGFloat = 30.0

public struct Palette {
  static let main = UIColor(red: 237.0 / 255.0, green: 140.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
  static let blue = UIColor(red: 140.0 / 255.0, green: 155.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
  static let pink = UIColor(red: 237.0 / 255.0, green: 140 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
  static let red = UIColor(red: 237.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
  static let green = UIColor(red: 86 / 255.0, green: 202 / 255.0, blue: 139 / 255.0, alpha: 1.0)
}
