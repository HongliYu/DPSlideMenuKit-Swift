//
//  DPLeftPageViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPLeftPageViewController: UIPageViewController {
  
  var transitionCompleted:((_ index: Int)->Void)?
  private(set) var leftContentViewControllers: [DPLeftContentViewController]?
  
  func setContentViewControllers(_ leftContentViewControllers: [DPLeftContentViewController]) {
    self.leftContentViewControllers = leftContentViewControllers
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
  }
  
  func basicUI() {
    guard let leftContentViewControllers = leftContentViewControllers,
      leftContentViewControllers.count > 0 else { return }
    delegate = self
    dataSource = self
    view.frame = CGRect(x: 0, y: 0,
                        width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                        height: view.bounds.height)
    if leftContentViewControllers.count == 1 {
      for view in view.subviews {
        if let scrollView = view as? UIScrollView {
          scrollView.bounces = false
        }
      }
    }
    setViewControllers([leftContentViewControllers[0]],
                       direction: .reverse, animated: false, completion: nil)
  }
  
  func resetUI() {
    view.frame = CGRect(x: 0, y: 0,
                        width: UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset,
                        height: view.bounds.height)
  }
  
  func scrollToViewController(index newIndex: Int) {
    guard let firstViewController = self.viewControllers?.first as? DPLeftContentViewController,
      let leftContentViewControllers = leftContentViewControllers,
      let currentIndex = leftContentViewControllers.index(of: firstViewController) else {
      return
    }
    let direction: UIPageViewController.NavigationDirection =
      (newIndex >= currentIndex) ? .forward : .reverse
    let nextViewController = leftContentViewControllers[newIndex]
    scrollToViewController(nextViewController, direction: direction)
  }

  private func scrollToViewController(_ viewController: UIViewController,
                                      direction: UIPageViewController.NavigationDirection = .forward) {
    setViewControllers([viewController],
                       direction: direction,
                       animated: true,
                       completion: { [weak self] (finished) -> Void in
        // Setting the view controller programmatically does not fire
        // any delegate methods, so we have to manually notify the new index.
        guard let strongSelf = self else { return }
        guard let firstViewController = strongSelf.viewControllers?.first as? DPLeftContentViewController,
          let leftContentViewControllers = strongSelf.leftContentViewControllers,
          let index = leftContentViewControllers.index(of: firstViewController) else {
            return
        }
        strongSelf.transitionCompleted?(index)
    })
  }
  
}


extension DPLeftPageViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let leftContentViewControllers = leftContentViewControllers,
      leftContentViewControllers.count >= 2,
      let viewController = viewController as? DPLeftContentViewController else {
      return nil
    }
    
    let index = leftContentViewControllers.index(of: viewController)
    let nextIndex = index! + 1
    let orderedViewControllersCount = leftContentViewControllers.count
    
    // User is on the last view controller and swiped right to loop to
    // the first view controller.
    guard orderedViewControllersCount != nextIndex else {
      return leftContentViewControllers.first
    }
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    return leftContentViewControllers[nextIndex]
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let leftContentViewControllers = leftContentViewControllers,
      leftContentViewControllers.count >= 2,
      let viewController = viewController as? DPLeftContentViewController else {
        return nil
    }

    let index = leftContentViewControllers.index(of: viewController)
    let previousIndex = index! - 1
    
    // User is on the first view controller and swiped left to loop to
    // the last view controller.
    guard previousIndex >= 0 else {
      return leftContentViewControllers.last
    }
    guard leftContentViewControllers.count > previousIndex else {
      return nil
    }
    return leftContentViewControllers[previousIndex]
  }

}

extension DPLeftPageViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 didFinishAnimating finished: Bool,
                                 previousViewControllers: [UIViewController],
                                 transitionCompleted completed: Bool) {
    if let pendingViewController = pageViewController.viewControllers?.first as? DPLeftContentViewController,
      let leftContentViewControllers = leftContentViewControllers,
      let index = leftContentViewControllers.index(of: pendingViewController) {
      if completed {
        self.transitionCompleted?(index)
      }
    }
  }

}
