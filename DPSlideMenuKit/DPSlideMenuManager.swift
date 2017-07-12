//
//  DPSlideMenuManager.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 06/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPSlideMenuManager {
  
  static let shared = DPSlideMenuManager()
  fileprivate (set) var drawer: DPDrawerViewController?
  fileprivate (set) var leftContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  fileprivate (set) var leftContentViewControllers: [DPLeftContentViewController] = []

  fileprivate (set) var rightContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  fileprivate (set) var rightContentViewControllers: [DPRightContentViewController] = []

  fileprivate (set) var leftMenuViewController: DPLeftMenuViewController?
  fileprivate (set) var rightMenuViewController: DPRightMenuViewController?

  fileprivate func config(leftContentEmbedViewControllers: [DPBaseEmbedViewController],
                          rightContentEmbedViewControllers: [DPBaseEmbedViewController]) {
    self.leftContentEmbedViewControllers = leftContentEmbedViewControllers
    leftContentEmbedViewControllers.count.times {
      self.leftContentViewControllers.append(DPLeftContentViewController())
    }
    for (index, leftContentViewController) in self.leftContentViewControllers.enumerated() {
      let leftContentEmbedViewController = self.leftContentEmbedViewControllers[index]
      leftContentEmbedViewController.setPositionState(positionState: .left)
      leftContentViewController.config(embedViewController: leftContentEmbedViewController)
    }
    self.rightContentEmbedViewControllers = rightContentEmbedViewControllers
    rightContentEmbedViewControllers.count.times {
      self.rightContentViewControllers.append(DPRightContentViewController())
    }
    for (index, rightContentViewController) in self.rightContentViewControllers.enumerated() {
      let rightContentEmbedViewController = self.rightContentEmbedViewControllers[index]
      rightContentEmbedViewController.setPositionState(positionState: .right)
      rightContentViewController.config(embedViewController: rightContentEmbedViewController)
    }
  }
  
  func setDrawer(drawer: DPDrawerViewController?) {
    self.drawer = drawer
  }
  
  func replaceCenterViewControllerWith(viewController: DPCenterContentViewController,
                                       position: DPEmbedViewControllerPositionState) {
    if position == .left {
      self.drawer?.leftMenuReplaceCenterViewControllerWithViewController(viewController)
    }
    if position == .right {
      self.drawer?.rightMenuReplaceCenterViewControllerWithViewController(viewController)
    }
  }
  
  func setup(leftContentEmbedViewControllers: [DPBaseEmbedViewController],
             rightContentEmbedViewControllers: [DPBaseEmbedViewController],
             centerContentViewController: DPCenterContentViewController?) {
    self.config(leftContentEmbedViewControllers: leftContentEmbedViewControllers,
                rightContentEmbedViewControllers: rightContentEmbedViewControllers)
    self.leftMenuViewController = DPLeftMenuViewController()
    self.rightMenuViewController = DPRightMenuViewController()
    self.drawer?.reset(leftViewController: leftMenuViewController,
                       rightMenuViewController: rightMenuViewController,
                       centerContentViewController: centerContentViewController)
  }
  
}
