//
//  DPRightMenuViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 10/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPRightMenuViewController: DPBaseMenuViewController {
  
  open var pageViewController: DPRightPageViewController =
    DPRightPageViewController(transitionStyle: .scroll,
                              navigationOrientation: .horizontal,
                              options: [.interPageSpacing: 0])
  
  override open func basicUI() {
    super.basicUI()
    pageViewController.setContentViewControllers(DPSlideMenuManager.shared.rightContentViewControllers)
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    if DPSlideMenuManager.shared.rightContentViewControllers.count > 1 {
      pageControl.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - kDPPageControlHeight,
                                 width: (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset),
                                 height: kDPPageControlHeight)
      pageControl.backgroundColor = UIColor.clear
      pageControl.currentPage = 0
      pageControl.numberOfPages = DPSlideMenuManager.shared.rightContentViewControllers.count
      pageControl.addTarget(self, action: #selector(pageAction(_:)), for: .valueChanged)
      view.addSubview(pageControl)
    }
  }
  
  override open func bindActions() {
    super.bindActions()
    pageViewController.transitionCompleted = {
      [weak self] index in
      guard let strongSelf = self else { return }
      strongSelf.pageControl.currentPage = index
    }
  }
  
  @objc func pageAction(_ sender: UIPageControl) {
    let pageIndex = sender.currentPage
    pageViewController.scrollToViewController(index: pageIndex)
  }

}
