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
  private(set) var rightContentViewControllers: [DPRightContentViewController]?
  
  public func setContentViewControllers(_ rightContentViewControllers: [DPRightContentViewController]) {
    self.rightContentViewControllers = rightContentViewControllers
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
  }
  
  public func basicUI() {
    guard let rightContentViewControllers = rightContentViewControllers,
      rightContentViewControllers.count > 0 else { return }

    delegate = self
    dataSource = self
    view.frame = CGRect(x: 0, y: 0,
                        width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                        height: view.bounds.height)
    guard rightContentViewControllers.count > 0 else {
      return
    }
    if rightContentViewControllers.count == 1 {
      for view in view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.bounces = false
        }
      }
    }
    setViewControllers([rightContentViewControllers[0]],
                       direction: .reverse, animated: false, completion: nil)
  }
  
  public func resetUI() {
    view.frame = CGRect(x: 0, y: 0,
                        width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                        height: view.bounds.height)
  }
  
  public func scrollToViewController(index newIndex: Int) {
    guard let rightContentViewControllers = rightContentViewControllers,
      let firstViewController = viewControllers?.first as? DPRightContentViewController,
      let currentIndex = rightContentViewControllers.firstIndex(of: firstViewController) else {
        return
    }
    let direction: UIPageViewController.NavigationDirection =
      (newIndex >= currentIndex) ? .forward : .reverse
    let nextViewController = rightContentViewControllers[newIndex]
    scrollToViewController(nextViewController, direction: direction)
  }
  
  public func scrollToViewController(_ viewController: UIViewController,
                                     direction: UIPageViewController.NavigationDirection = .forward) {
    setViewControllers([viewController],
                       direction: direction,
                       animated: true,
                       completion: { [weak self](finished) -> Void in
      guard let strongSelf = self else { return }
      guard let firstViewController = strongSelf.viewControllers?.first as? DPRightContentViewController,
        let rightContentViewControllers = strongSelf.rightContentViewControllers,
        let index = rightContentViewControllers.firstIndex(of: firstViewController) else {
          return
      }
      strongSelf.transitionCompleted?(index)
    })
  }
  
}

extension DPRightPageViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let rightContentViewControllers = rightContentViewControllers,
      rightContentViewControllers.count >= 2,
      let viewController = viewController as? DPRightContentViewController else {
        return nil
    }
    
    let index = rightContentViewControllers.firstIndex(of: viewController)
    let nextIndex = index! + 1
    let orderedViewControllersCount = rightContentViewControllers.count
    
    // User is on the last view controller and swiped right to loop to
    // the first view controller.
    guard orderedViewControllersCount != nextIndex else {
      return rightContentViewControllers.first
    }
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    return rightContentViewControllers[nextIndex]
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let rightContentViewControllers = rightContentViewControllers,
      rightContentViewControllers.count >= 2,
      let viewController = viewController as? DPRightContentViewController else {
        return nil
    }

    let index = rightContentViewControllers.firstIndex(of: viewController)
    let previousIndex = index! - 1
    
    // User is on the first view controller and swiped left to loop to
    // the last view controller.
    guard previousIndex >= 0 else {
      return rightContentViewControllers.last
    }
    guard rightContentViewControllers.count > previousIndex else {
      return nil
    }
    return rightContentViewControllers[previousIndex]
  }
  
}

extension DPRightPageViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 didFinishAnimating finished: Bool,
                                 previousViewControllers: [UIViewController],
                                 transitionCompleted completed: Bool) {
    if let pendingViewController = pageViewController.viewControllers?.first as? DPRightContentViewController,
      let rightContentViewControllers = rightContentViewControllers,
      let index = rightContentViewControllers.firstIndex(of: pendingViewController) {
      if completed {
        self.transitionCompleted?(index)
      }
    }
  }
  
}
