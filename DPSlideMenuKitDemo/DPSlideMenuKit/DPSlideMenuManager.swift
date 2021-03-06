//
//  DPSlideMenuManager.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 06/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPSlideMenuManager {
  
  public static let shared = DPSlideMenuManager()
  private(set) var drawer: DPDrawerViewController?
  private(set) var leftContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  private(set) var leftContentViewControllers: [DPLeftContentViewController] = []

  private(set) var rightContentEmbedViewControllers: [DPBaseEmbedViewController] = []
  private(set) var rightContentViewControllers: [DPRightContentViewController] = []

  private(set) var leftMenuViewController: DPLeftMenuViewController?
  private(set) var rightMenuViewController: DPRightMenuViewController?

  public func setDrawer(drawer: DPDrawerViewController?) {
    self.drawer = drawer
  }
  
  public func replaceCenter(_ viewController: DPCenterContentViewController,
                            position: MenuPosition) {
    drawer?.replaceCenterViewController(viewController, menuPosition: position)
  }
  
  public func setup(_ centerContentViewController: DPCenterContentViewController,
                    leftContentEmbedViewControllers: [DPBaseEmbedViewController]?,
                    rightContentEmbedViewControllers: [DPBaseEmbedViewController]?) {
    leftMenuViewController = leftContentEmbedViewControllers == nil ? nil : DPLeftMenuViewController()
    rightMenuViewController = rightContentEmbedViewControllers == nil ? nil : DPRightMenuViewController()
    config(leftContentEmbedViewControllers: leftContentEmbedViewControllers,
           rightContentEmbedViewControllers: rightContentEmbedViewControllers)
    drawer?.config(centerContentViewController,
                   leftViewController: leftMenuViewController,
                   rightMenuViewController: rightMenuViewController)
  }
  
  private func config(leftContentEmbedViewControllers: [DPBaseEmbedViewController]?,
                      rightContentEmbedViewControllers: [DPBaseEmbedViewController]?) {
    if let leftContentEmbedViewControllers = leftContentEmbedViewControllers {
      self.leftContentEmbedViewControllers = leftContentEmbedViewControllers
      self.leftContentEmbedViewControllers.count.times {
        self.leftContentViewControllers.append(DPLeftContentViewController())
      }
      for (index, leftContentViewController) in self.leftContentViewControllers.enumerated() {
        let leftContentEmbedViewController = self.leftContentEmbedViewControllers[index]
        leftContentEmbedViewController.setPositionState(positionState: .left)
        leftContentViewController.config(leftContentEmbedViewController)
      }
    }
    if let rightContentEmbedViewControllers = rightContentEmbedViewControllers {
      self.rightContentEmbedViewControllers = rightContentEmbedViewControllers
      self.rightContentEmbedViewControllers.count.times {
        self.rightContentViewControllers.append(DPRightContentViewController())
      }
      for (index, rightContentViewController) in self.rightContentViewControllers.enumerated() {
        let rightContentEmbedViewController = self.rightContentEmbedViewControllers[index]
        rightContentEmbedViewController.setPositionState(positionState: .right)
        rightContentViewController.config(rightContentEmbedViewController)
      }
    }
  }

}
