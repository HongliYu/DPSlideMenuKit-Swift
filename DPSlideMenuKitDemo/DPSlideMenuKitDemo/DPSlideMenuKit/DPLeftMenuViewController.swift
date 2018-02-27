//
//  DPLeftMenuViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import Foundation

public class DPLeftMenuViewController: UIViewController {
  
  var drawerControllerWillOpen:(()->Void)?
  var drawerControllerDidOpen:(()->Void)?
  var drawerControllerWillClose:(()->Void)?
  var drawerControllerDidClose:(()->Void)?
  
  fileprivate (set) var pageControl: UIPageControl = UIPageControl()
  fileprivate (set) var pageViewController: DPLeftPageViewController = DPLeftPageViewController(transitionStyle: .scroll,
                                                                                                navigationOrientation: .horizontal,
                                                                                                options: [UIPageViewControllerOptionInterPageSpacingKey: 0])
  
  // MARK: Life Cycle
  override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
    self.basicData()
  }
  
  func basicUI() {
    self.view.backgroundColor = Palette.green
    self.addChildViewController(self.pageViewController)
    self.view.addSubview(self.pageViewController.view)
    if DPSlideMenuManager.shared.leftContentViewControllers.count > 1 {
      self.pageControl.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - kDPPageControlHeight,
                                      width: (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset),
                                      height: kDPPageControlHeight)
      self.pageControl.backgroundColor = UIColor.clear
      self.pageControl.currentPage = 0
      self.pageControl.numberOfPages = DPSlideMenuManager.shared.leftContentViewControllers.count
      self.pageControl.addTarget(self, action: #selector(self.pageAction(_:)), for: .valueChanged)
      self.view.addSubview(self.pageControl)
    }
  }
  
  func resetUI() {
    var frame: CGRect = self.pageControl.frame
    frame.origin.y = UIScreen.main.bounds.height - kDPPageControlHeight
    self.pageControl.frame = frame
  }

  func basicData() {
    self.pageViewController.transitionCompleted = {
      [weak self] index in
      guard let strongSelf = self else { return }
      strongSelf.pageControl.currentPage = index
    }
    self.drawerControllerWillOpen = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
    }
    self.drawerControllerDidOpen = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }
    self.drawerControllerWillClose = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
    }
    self.drawerControllerDidClose = {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }
  }
  
  @objc func pageAction(_ sender: UIPageControl) {
    let pageIndex = sender.currentPage
    self.pageViewController.scrollToViewController(index: pageIndex)
  }
  
  override public var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil) { (UIViewControllerTransitionCoordinatorContext) in
      self.resetUI()
    }
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
