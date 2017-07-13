//
//  DPRightPageViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 10/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPRightPageViewController: UIPageViewController {

  var transitionCompleted:((_ index: Int)->Void)?
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle,
                navigationOrientation: UIPageViewControllerNavigationOrientation,
                options: [String : Any]? = nil) {
    super.init(transitionStyle: style,
               navigationOrientation: navigationOrientation,
               options: options)
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
    self.delegate = self
    self.dataSource = self
    self.view.frame = CGRect(x: 0, y: 0,
                             width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                             height: self.view.bounds.height)
    guard DPSlideMenuManager.shared.rightContentViewControllers.count > 0 else {
      return
    }
    if DPSlideMenuManager.shared.rightContentViewControllers.count == 1 {
      for view in self.view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.bounces = false
        }
      }
    }
    self.setViewControllers([DPSlideMenuManager.shared.rightContentViewControllers.first!],
                            direction: .reverse,
                            animated: false) { (finished) in
                              if finished {
                                // TODO: embed action lazy set
                              }
    }
  }
  
  func resetUI() {
    self.view.frame = CGRect(x: 0, y: 0,
                             width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                             height: self.view.bounds.height)
  }

  func basicData() {
    
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = self.viewControllers!.first,
      let currentIndex = DPSlideMenuManager.shared.rightContentViewControllers.index(of: firstViewController as! DPRightContentViewController) {
      let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = DPSlideMenuManager.shared.rightContentViewControllers[newIndex]
      self.scrollToViewController(nextViewController, direction: direction)
    }
  }
  
  fileprivate func scrollToViewController(_ viewController: UIViewController,
                                          direction: UIPageViewControllerNavigationDirection = .forward) {
    setViewControllers([viewController],
                       direction: direction,
                       animated: true,
                       completion: { (finished) -> Void in
                        // Setting the view controller programmatically does not fire
                        // any delegate methods, so we have to manually notify the new index.
                        if let firstViewController = self.viewControllers?.first,
                          let index = DPSlideMenuManager.shared.rightContentViewControllers.index(of: firstViewController as! DPRightContentViewController) {
                          self.transitionCompleted?(index)
                        }
    })
  }
  
  fileprivate func adaptData(viewController: DPRightContentViewController) {
    // TODO: lazy init, the strategy for now is to generate all right vcs at the very beginning
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

extension DPRightPageViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if DPSlideMenuManager.shared.rightContentViewControllers.count <= 1 {
      return nil
    }
    
    // after, swipe left
    if let viewController = viewController as? DPRightContentViewController {
      self.adaptData(viewController: viewController)
    }
    
    let index = DPSlideMenuManager.shared.rightContentViewControllers.index(of: viewController as! DPRightContentViewController)
    let nextIndex = index! + 1
    let orderedViewControllersCount = DPSlideMenuManager.shared.rightContentViewControllers.count
    
    // User is on the last view controller and swiped right to loop to
    // the first view controller.
    guard orderedViewControllersCount != nextIndex else {
      return DPSlideMenuManager.shared.rightContentViewControllers.first
    }
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    return DPSlideMenuManager.shared.rightContentViewControllers[nextIndex]
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if DPSlideMenuManager.shared.rightContentViewControllers.count <= 1 {
      return nil
    }
    
    // before, swipe right
    if let viewController = viewController as? DPRightContentViewController {
      self.adaptData(viewController: viewController)
    }
    let index = DPSlideMenuManager.shared.rightContentViewControllers.index(of: viewController as! DPRightContentViewController)
    let previousIndex = index! - 1
    
    // User is on the first view controller and swiped left to loop to
    // the last view controller.
    guard previousIndex >= 0 else {
      return DPSlideMenuManager.shared.rightContentViewControllers.last
    }
    guard DPSlideMenuManager.shared.rightContentViewControllers.count > previousIndex else {
      return nil
    }
    return DPSlideMenuManager.shared.rightContentViewControllers[previousIndex]
  }
  
}

extension DPRightPageViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                          willTransitionTo pendingViewControllers: [UIViewController]) {
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    if let pendingViewController = pageViewController.viewControllers?.first as? DPRightContentViewController,
      let index = DPSlideMenuManager.shared.rightContentViewControllers.index(of: pendingViewController) {
      if completed {
        self.transitionCompleted?(index)
      }
    }
  }
  
}
