//
//  DPBaseMenuViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 2018/12/19.
//  Copyright © 2018 Hongli Yu. All rights reserved.
//

import UIKit

public class DPBaseMenuViewController: UIViewController {
  
  open var drawerControllerWillOpen:(()->Void)?
  open var drawerControllerDidOpen:(()->Void)?
  open var drawerControllerWillClose:(()->Void)?
  open var drawerControllerDidClose:(()->Void)?

  open var pageControl: UIPageControl = UIPageControl()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
    self.basicData()
    self.bindActions()
  }
  
  open func basicUI() {
    view.backgroundColor = Palette.green
  }
  
  open func resetUI() {
    var frame: CGRect = pageControl.frame
    frame.origin.y = UIScreen.main.bounds.height - kDPPageControlHeight
    pageControl.frame = frame
  }
  
  open func basicData() {
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
  
  open func bindActions() {
    
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
