//
//  DPSlideMenuManager.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 06/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

open class DPSlideMenuManager {
  
  public static let shared = DPSlideMenuManager()
  fileprivate (set) var drawer: DPDrawerViewController?
  fileprivate (set) var leftContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  fileprivate (set) var leftContentViewControllers: [DPLeftContentViewController] = []

  fileprivate (set) var rightContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  fileprivate (set) var rightContentViewControllers: [DPRightContentViewController] = []

  fileprivate (set) var leftMenuViewController: DPLeftMenuViewController?
  fileprivate (set) var rightMenuViewController: DPRightMenuViewController?

  fileprivate func config(leftContentEmbedViewControllers: [DPBaseEmbedViewController]?,
                          rightContentEmbedViewControllers: [DPBaseEmbedViewController]?) {
    if leftContentEmbedViewControllers != nil {
      self.leftContentEmbedViewControllers = leftContentEmbedViewControllers!
      self.leftContentEmbedViewControllers.count.times {
        self.leftContentViewControllers.append(DPLeftContentViewController())
      }
      for (index, leftContentViewController) in self.leftContentViewControllers.enumerated() {
        let leftContentEmbedViewController = self.leftContentEmbedViewControllers[index]
        leftContentEmbedViewController.setPositionState(positionState: .left)
        leftContentViewController.config(embedViewController: leftContentEmbedViewController)
      }
    }
    if rightContentEmbedViewControllers != nil {
      self.rightContentEmbedViewControllers = rightContentEmbedViewControllers!
      self.rightContentEmbedViewControllers.count.times {
        self.rightContentViewControllers.append(DPRightContentViewController())
      }
      for (index, rightContentViewController) in self.rightContentViewControllers.enumerated() {
        let rightContentEmbedViewController = self.rightContentEmbedViewControllers[index]
        rightContentEmbedViewController.setPositionState(positionState: .right)
        rightContentViewController.config(embedViewController: rightContentEmbedViewController)
      }
    }
  }
  
  public func setDrawer(drawer: DPDrawerViewController?) {
    self.drawer = drawer
  }
  
  public func replaceCenterViewControllerWith(viewController: DPCenterContentViewController,
                                              position: DPEmbedViewControllerPositionState) {
    if position == .left {
      self.drawer?.leftMenuReplaceCenterViewControllerWithViewController(viewController)
    }
    if position == .right {
      self.drawer?.rightMenuReplaceCenterViewControllerWithViewController(viewController)
    }
  }
  
  public func setup(leftContentEmbedViewControllers: [DPBaseEmbedViewController]?,
                    rightContentEmbedViewControllers: [DPBaseEmbedViewController]?,
                    centerContentViewController: DPCenterContentViewController?) {
    leftMenuViewController = leftContentEmbedViewControllers == nil ? nil : DPLeftMenuViewController()
    rightMenuViewController = rightContentEmbedViewControllers == nil ? nil : DPRightMenuViewController()
    config(leftContentEmbedViewControllers: leftContentEmbedViewControllers,
           rightContentEmbedViewControllers: rightContentEmbedViewControllers)
    drawer?.reset(leftViewController: leftMenuViewController,
                  rightMenuViewController: rightMenuViewController,
                  centerContentViewController: centerContentViewController)
  }
  
}
