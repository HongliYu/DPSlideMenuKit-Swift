//
//  DPDrawerViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

public class DPDrawerViewController: UIViewController, UIGestureRecognizerDelegate {
  
  fileprivate(set) var leftMenuViewController: DPLeftMenuViewController?
  fileprivate(set) var rightMenuViewController: DPRightMenuViewController?
  fileprivate(set) var centerContentViewController: DPCenterContentViewController?
  fileprivate(set) var drawerState: DPDrawerControllerState = .closed

  fileprivate var leftView: UIView?
  fileprivate var rightView: DPDropShadowView?
  fileprivate var centerView: DPDropShadowView?
  fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
  fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
  fileprivate var panGestureStartLocation: CGPoint?
  fileprivate var createdFormStoryboard: Bool = false

  // MARK: Life Cycle
  init(leftViewController: DPLeftMenuViewController?,
       rightMenuViewController: DPRightMenuViewController?,
       centerViewController: DPCenterContentViewController?) {
    super.init(nibName: nil, bundle: nil)
    self.leftMenuViewController = leftViewController
    self.rightMenuViewController = rightMenuViewController
    self.centerContentViewController = centerViewController
    self.createdFormStoryboard = false
    self.basicUI()
  }
    
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.createdFormStoryboard = true
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  func reset(leftViewController: DPLeftMenuViewController?,
             rightMenuViewController: DPRightMenuViewController?,
             centerContentViewController: DPCenterContentViewController?) {
    self.leftMenuViewController = leftViewController
    self.rightMenuViewController = rightMenuViewController
    self.centerContentViewController = centerContentViewController
    self.createdFormStoryboard = false
    self.basicUI()
  }
  
  func basicUI() {
    if self.createdFormStoryboard {
      return
    }
    self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.leftView = UIView(frame: self.view.bounds)
    self.rightView = DPDropShadowView(frame: self.view.bounds)
    
    self.centerView = DPDropShadowView(frame: self.view.bounds)
    self.leftView?.autoresizingMask = self.view.autoresizingMask
    self.rightView?.autoresizingMask = self.view.autoresizingMask
    self.centerView?.autoresizingMask = self.view.autoresizingMask
    
    // Add the center view container
    self.view.addSubview(self.centerView!)
    
    // Add the center view controller to the container
    self.addCenterViewController()
    self.setupGestureRecognizers()
  }
  
  override public var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
  }
  
  func addCenterViewController() {
    if let centerViewController = self.centerContentViewController {
      self.addChildViewController(centerViewController)
      centerViewController.view.frame = self.view.bounds
      self.centerView?.addSubview(centerViewController.view)
      centerViewController.didMove(toParentViewController: self)
    }
  }

  // MARK: Layout
  override public var childViewControllerForStatusBarHidden :UIViewController {
    if (self.drawerState == .leftOpening) {
      return self.leftMenuViewController!
    }
    if (self.drawerState == .rightOpening) {
      return self.rightMenuViewController!
    }
    return self.centerContentViewController!
  }
  
  override public var childViewControllerForStatusBarStyle :UIViewController {
    if (self.drawerState == .leftOpening) {
      return self.leftMenuViewController!
    }
    if (self.drawerState == .rightOpening) {
      return self.rightMenuViewController!
    }
    return self.centerContentViewController!
  }
  
  // MARK: Gestures
  func setupGestureRecognizers() {
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.tapGestureRecognized(_:)))
    self.panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(self.panGestureRecognized(_:)))
    self.panGestureRecognizer?.maximumNumberOfTouches = 1
    self.panGestureRecognizer?.delegate = self
    self.centerView?.addGestureRecognizer(self.panGestureRecognizer!)
  }
  
  func addClosingGestureRecognizers() {
    if let tapGestureRecognizer = self.tapGestureRecognizer {
      self.centerView?.addGestureRecognizer(tapGestureRecognizer)
    }
  }

  func removeClosingGestureRecognizers() {
    if let tapGestureRecognizer = self.tapGestureRecognizer {
      self.centerView?.removeGestureRecognizer(tapGestureRecognizer)
    }
  }
  
  func tapGestureRecognized(_ tapGestureRecognizer: UITapGestureRecognizer) {
    if (tapGestureRecognizer.state == .ended) {
      if self.drawerState == .leftOpen {
        self.leftClose()
      }
      if self.drawerState == .rightOpen {
        self.rightClose()
      }
    }
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity: CGPoint? = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: self.view)
    if self.drawerState == .closed {
      return true
    } else if self.drawerState == .leftOpen, let velocityX = velocity?.x, velocityX < CGFloat(0.0) { // swipe to left
      return true
    } else if self.drawerState == .rightOpen, let velocityX = velocity?.x, velocityX > CGFloat(0.0) { // swipe to right
      return true
    }
    return false
  }
  
  func panGestureRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let state: UIGestureRecognizerState = panGestureRecognizer.state
    let location: CGPoint = panGestureRecognizer.location(in: self.view)
    let velocity: CGPoint = panGestureRecognizer.velocity(in: self.view)
    let velocityX = velocity.x
    
    switch state {
    case .began:
      self.panGestureStartLocation = location
      if self.drawerState == .closed {
        if velocityX < CGFloat(0.0) {
          self.rightWillOpen()
        } else {
          self.leftWillOpen()
        }
      } else {
        if self.drawerState == .leftOpen {
          self.leftWillClose()
        }
        if self.drawerState == .rightOpen {
          self.rightWillClose()
        }
      }
      break
    case .changed:
      if self.drawerState == .leftOpening
        || self.drawerState == .leftClosing {
        var delta: CGFloat = 0.0
        if self.drawerState == .leftOpening {
          delta = location.x - self.panGestureStartLocation!.x
        } else if (self.drawerState == .leftClosing) {
          delta = (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset) - (self.panGestureStartLocation!.x - location.x)
        }
        var leftFrame: CGRect? = self.leftView!.frame
        var centerFrame: CGRect? = self.centerView!.frame
        
        if (delta > (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset)) {
          leftFrame!.origin.x = 0.0
          centerFrame!.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
        } else if (delta < 0.0) {
          leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
          centerFrame!.origin.x = 0.0
        } else {
          // parallax effect
          leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
            - (delta * kDPDrawerControllerLeftViewInitialOffset) / (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset)
          centerFrame!.origin.x = delta
        }
        self.leftView!.frame = leftFrame!
        self.centerView!.frame = centerFrame!
      }
      if self.drawerState == .rightOpening
        || self.drawerState == .rightClosing {
        let delta: CGFloat = abs(location.x - self.panGestureStartLocation!.x)
        if self.drawerState == .rightOpening {
          var rightFrame: CGRect? = self.rightView!.frame
          rightFrame!.origin.x = self.view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset - delta
          self.rightView!.frame = rightFrame!
        } else if (self.drawerState == .rightClosing) {
          var rightFrame: CGRect? = self.rightView!.frame
          rightFrame!.origin.x = kDPDrawerControllerDrawerWidthGapOffset + delta
          self.rightView!.frame = rightFrame!
        }
      }
      break
    case .ended:
      if (self.drawerState == .leftOpening) {
        let centerViewLocationX: CGFloat = self.centerView!.frame.origin.x
        if (centerViewLocationX == (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset)) {
          self.setNeedsStatusBarAppearanceUpdate()
          self.leftDidOpen()
        } else if (centerViewLocationX > self.view.bounds.size.width / 3.0
          && velocity.x > 0.0) {
          self.leftOpening(animated: true)
        } else {
          self.leftDidOpen()
          self.leftWillClose()
          self.leftClosing(animated: true)
        }
      } else if (self.drawerState == .leftClosing) {
        let centerViewLocationX: CGFloat = self.centerView!.frame.origin.x
        if (centerViewLocationX == 0.0) {
          // Close the drawer without animation, as it has already being dragged in its final position
          self.setNeedsStatusBarAppearanceUpdate()
          self.leftDidClose()
        } else if (centerViewLocationX < (2 * self.view.bounds.size.width) / 3.0
          && velocity.x < 0.0) {
          self.leftClosing(animated: true)
        } else {
          self.leftDidClose()
          let leftFrame: CGRect = self.leftView!.frame
          self.leftWillOpen()
          self.leftView!.frame = leftFrame
          self.leftOpening(animated: true)
        }
      }
      
      if (self.drawerState == .rightOpening) {
        let rightViewLocationX: CGFloat = self.rightView!.frame.origin.x
        if rightViewLocationX == kDPDrawerControllerDrawerWidthGapOffset {
          self.setNeedsStatusBarAppearanceUpdate()
          self.rightDidOpen()
        } else if (rightViewLocationX < (2 * self.view.bounds.size.width) / 3.0
          && velocity.x < 0.0) {
          self.rightOpening(animated: true)
        } else {
          self.rightDidOpen()
          self.rightWillClose()
          self.rightClosing(animated: true)
        }
      } else if self.drawerState == .rightClosing {
        let rightViewLocationX: CGFloat = self.rightView!.frame.origin.x
        if rightViewLocationX == self.view.bounds.width {
          // Close the drawer without animation, as it has already being dragged in its final position
          self.setNeedsStatusBarAppearanceUpdate()
          self.rightDidClose()
        } else if (rightViewLocationX > self.view.bounds.size.width / 3.0
          && velocity.x > 0.0) {
          self.rightClosing(animated: true)
        } else {
          self.rightDidClose()
          let rightFrame: CGRect = self.rightView!.frame
          self.rightWillOpen()
          self.rightView!.frame = rightFrame
          self.rightOpening(animated: true)
        }
      }
      
      break
    default:
      break
    }
  }

  // MARK: Animations
  func leftOpening(animated: Bool) {
    let leftViewFinalFrame: CGRect = self.view.bounds
    var centerViewFinalFrame: CGRect = self.view.bounds
    centerViewFinalFrame.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerOpeningAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerOpeningAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.centerView!.frame = centerViewFinalFrame
                      self.leftView!.frame = leftViewFinalFrame
                      self.setNeedsStatusBarAppearanceUpdate()
      }) { (finished) in
        self.leftDidOpen()
      }
    } else {
      self.centerView!.frame = centerViewFinalFrame
      self.leftView!.frame = leftViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
      self.leftDidOpen()
    }
  }
  
  func rightOpening(animated: Bool) {
    var rightViewFinalFrame: CGRect = self.view.bounds
    rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerOpeningAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerOpeningAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView!.frame = rightViewFinalFrame
                      self.setNeedsStatusBarAppearanceUpdate()
      }) { (finished) in
        self.rightDidOpen()
      }
    } else {
      self.rightView!.frame = rightViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
      self.rightDidOpen()
    }
  }
  
  func leftClosing(animated: Bool) {
    var leftViewFinalFrame: CGRect = self.leftView!.frame
    leftViewFinalFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    let centerViewFinalFrame: CGRect = self.view.bounds
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.centerView!.frame = centerViewFinalFrame
                      self.leftView!.frame = leftViewFinalFrame
                      self.setNeedsStatusBarAppearanceUpdate()
      }) { (finished) in
        self.leftDidClose()
      }
    } else {
      self.centerView!.frame = centerViewFinalFrame
      self.leftView!.frame = leftViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
      self.leftDidClose()
    }
  }
  
  func rightClosing(animated: Bool) {
    var rightViewFinalFrame: CGRect = self.rightView!.frame
    rightViewFinalFrame.origin.x = self.view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView!.frame = rightViewFinalFrame
                      self.setNeedsStatusBarAppearanceUpdate()
      }) { (finished) in
        self.rightDidClose()
      }
    } else {
      self.rightView!.frame = rightViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
      self.rightDidClose()
    }
  }
  
  // MARK: Opening the drawer
  func leftOpen() {
    self.leftWillOpen()
    self.leftOpening(animated: true)
  }
  
  func rightOpen() {
    self.rightWillOpen()
    self.rightOpening(animated: true)
  }

  func leftWillOpen() {
    UIApplication.shared.isStatusBarHidden = true
    self.drawerState = .leftOpening
    
    // Position the left view
    var frame: CGRect = self.view.bounds
    frame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    self.leftView!.frame = frame
    
    // Start adding the left view controller to the container
    self.addChildViewController(self.leftMenuViewController!)
    self.leftMenuViewController!.view.frame = self.leftView!.bounds
    self.leftView!.addSubview(self.leftMenuViewController!.view)
    
    // Add the left view to the view hierarchy
    self.view.insertSubview(self.leftView!,
                            belowSubview: self.centerView!)
    
    // Notify the child view controllers that the drawer is about to open
    self.leftMenuViewController?.drawerControllerWillOpen?()
    self.centerContentViewController?.drawerControllerWillOpen?(true)
  }
  
  func rightWillOpen() {
    UIApplication.shared.isStatusBarHidden = true

    self.drawerState = .rightOpening
    
    // Position the right view
    var frame: CGRect = self.view.bounds
    frame.origin.x = self.view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    self.rightView!.frame = frame
    
    // Start adding the right view controller to the container
    self.addChildViewController(self.rightMenuViewController!)
    self.rightMenuViewController!.view.frame = self.rightView!.bounds
    self.rightView!.addSubview(self.rightMenuViewController!.view)
    
    // Add the right view to the view hierarchy
    self.view.insertSubview(self.rightView!,
                            aboveSubview: self.centerView!)
    
    // Notify the child view controllers that the drawer is about to open
    self.rightMenuViewController?.drawerControllerWillOpen?()
    self.centerContentViewController?.drawerControllerWillOpen?(false)
  }
  
  func leftDidOpen() {
    // Complete adding the left controller to the container
    self.leftMenuViewController?.didMove(toParentViewController: self)
    self.addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    self.drawerState = .leftOpen
    
    // Notify the child view controllers that the drawer is open
    self.leftMenuViewController?.drawerControllerDidOpen?()
    self.centerContentViewController?.drawerControllerDidOpen?(true)
  }
  
  func rightDidOpen() {
    // Complete adding the left controller to the container
    self.rightMenuViewController?.didMove(toParentViewController: self)
    self.addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    self.drawerState = .rightOpen
    
    // Notify the child view controllers that the drawer is open
    self.rightMenuViewController?.drawerControllerDidOpen?()
    self.centerContentViewController?.drawerControllerDidOpen?(false)
  }
  
  func leftClose() {
    self.leftWillClose()
    self.leftClosing(animated: true)
  }
  
  func rightClose() {
    self.rightWillClose()
    self.rightClosing(animated: true)
  }
  
  func leftWillClose() {
    // Start removing the left controller from the container
    self.leftMenuViewController?.willMove(toParentViewController: nil)
    
    // Keep track that the drawer is closing
    self.drawerState = .leftClosing
    
    // Notify the child view controllers that the drawer is about to close
    self.leftMenuViewController?.drawerControllerWillClose?()
    self.centerContentViewController?.drawerControllerWillClose?(true)
  }
  
  func rightWillClose() {
    // Start removing the left controller from the container
    self.rightMenuViewController?.willMove(toParentViewController: nil)
    
    // Keep track that the drawer is closing
    self.drawerState = .rightClosing
    
    // Notify the child view controllers that the drawer is about to close
    self.rightMenuViewController?.drawerControllerWillClose?()
    self.centerContentViewController?.drawerControllerWillClose?(false)
  }

  func leftDidClose() {
    UIApplication.shared.isStatusBarHidden = false

    // Complete removing the left view controller from the container
    self.leftMenuViewController?.view.removeFromSuperview()
    self.leftMenuViewController?.removeFromParentViewController()

    // Remove the left view from the view hierarchy
    self.leftView?.removeFromSuperview()
    self.removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    self.drawerState = .closed

    // Notify the child view controllers that the drawer is closed
    self.leftMenuViewController?.drawerControllerDidClose?()
    self.centerContentViewController?.drawerControllerDidClose?(true)
  }
  
  func rightDidClose() {
    UIApplication.shared.isStatusBarHidden = false

    // Complete removing the left view controller from the container
    self.rightMenuViewController?.view.removeFromSuperview()
    self.rightMenuViewController?.removeFromParentViewController()
    
    // Remove the left view from the view hierarchy
    self.rightView?.removeFromSuperview()
    self.removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    self.drawerState = .closed
    
    // Notify the child view controllers that the drawer is closed
    self.rightMenuViewController?.drawerControllerDidClose?()
    self.centerContentViewController?.drawerControllerDidClose?(false)
  }

  func leftResetViewPosition(state: DPDrawerControllerState) {
    if state == .leftOpen {
      let leftViewFinalFrame: CGRect = self.view.bounds
      var centerViewFinalFrame: CGRect = self.view.bounds
      centerViewFinalFrame.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
      self.centerView!.frame = centerViewFinalFrame
      self.leftView!.frame = leftViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
    }
    if state == .closed {
      
    }
  }
  
  func rightResetViewPosition(state: DPDrawerControllerState) {
    if state == .leftOpen {
      var rightViewFinalFrame: CGRect = self.view.bounds
      rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
      self.rightView!.frame = rightViewFinalFrame
      self.setNeedsStatusBarAppearanceUpdate()
    }
    if state == .closed {
      
    }
  }

  // MARK: Reloading / Replacing the center view controller
  func leftMenuReloadCenterViewControllerUsingBlock(_ reloadBlock: (()->Void)?) {
    self.leftWillClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    UIView .animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0,
                    animations: {
                      self.centerView!.frame = frame
      }, completion: { (finished) in
        // The center view controller is now out of sight
        reloadBlock?()
        self.leftClosing(animated: true)
    }) 
  }
  
  func rightMenuReloadCenterViewControllerUsingBlock(_ reloadBlock: (()->Void)?) {
    self.rightWillClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    UIView .animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0,
                    animations: {
                      self.centerView!.frame = frame
    }, completion: { (finished) in
      // The center view controller is now out of sight
      reloadBlock?()
      self.rightClosing(animated: true)
    })
  }

  func leftMenuReplaceCenterViewControllerWithViewController(_ viewController: DPCenterContentViewController) {
    self.leftWillClose()
    self.centerContentViewController?.willMove(toParentViewController: nil)
    DPSlideMenuManager.shared.setDrawer(drawer: nil)
    self.centerContentViewController?.view.removeFromSuperview()
    self.centerContentViewController?.removeFromParentViewController()
    
    // Set the new center view controller
    self.centerContentViewController = viewController
    DPSlideMenuManager.shared.setDrawer(drawer: self)
    
    // Add the new center view controller to the container
    self.addCenterViewController()
    
    // Finally, close the drawer
    self.leftClosing(animated: true)
  }
  
  func rightMenuReplaceCenterViewControllerWithViewController(_ viewController: DPCenterContentViewController) {
    self.rightWillClose()
    self.centerContentViewController?.willMove(toParentViewController: nil)
    DPSlideMenuManager.shared.setDrawer(drawer: nil)
    self.centerContentViewController?.view.removeFromSuperview()
    self.centerContentViewController?.removeFromParentViewController()
    
    // Set the new center view controller
    self.centerContentViewController = viewController
    DPSlideMenuManager.shared.setDrawer(drawer: self)
    
    // Add the new center view controller to the container
    self.addCenterViewController()
    
    // Finally, close the drawer
    self.rightClosing(animated: true)
  }

  override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate(alongsideTransition: nil) { (UIViewControllerTransitionCoordinatorContext) in
      if self.drawerState == .leftOpen {
        self.leftResetViewPosition(state: .leftOpen)
      }
      if self.drawerState == .rightOpen {
        self.rightResetViewPosition(state: .rightOpen)
      }
      if self.drawerState == .closed {
        self.leftMenuViewController?.resetUI()
        self.rightMenuViewController?.resetUI()
      }
    }
    
  }

}
