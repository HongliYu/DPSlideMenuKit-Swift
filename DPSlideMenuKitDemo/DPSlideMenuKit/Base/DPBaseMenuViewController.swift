//
//  DPBaseMenuViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 2018/12/19.
//  Copyright © 2018 Hongli Yu. All rights reserved.
//

import UIKit

public class DPBaseMenuViewController: UIViewController {
  
  private(set) var drawerControllerWillOpen:(()->Void)?
  private(set) var drawerControllerDidOpen:(()->Void)?
  private(set) var drawerControllerWillClose:(()->Void)?
  private(set) var drawerControllerDidClose:(()->Void)?

  private(set) var pageControl: UIPageControl = UIPageControl()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
    self.basicData()
    self.bindActions()
  }
  
  func basicUI() {
    view.backgroundColor = Palette.green
  }
  
  func resetUI() {
    var frame: CGRect = pageControl.frame
    frame.origin.y = UIScreen.main.bounds.height - kDPPageControlHeight
    pageControl.frame = frame
  }
  
  func basicData() {
    drawerControllerWillOpen = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
    }
    drawerControllerDidOpen = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }
    drawerControllerWillClose = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
    }
    drawerControllerDidClose = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }
  }
  
  func bindActions() {
    
  }
  
  override public func viewWillTransition(to size: CGSize,
                                          with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil) {
      [weak self] (UIViewControllerTransitionCoordinatorContext) in
      guard let strongSelf = self else { return }
      strongSelf.resetUI()
    }
  }

}
