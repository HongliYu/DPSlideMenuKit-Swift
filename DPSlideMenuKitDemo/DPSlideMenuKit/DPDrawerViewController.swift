//
//  DPDrawerViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

public class DPDrawerViewController: UIViewController, UIGestureRecognizerDelegate {
  
  private var leftMenuViewController: DPLeftMenuViewController?
  private var rightMenuViewController: DPRightMenuViewController?
  private var centerContentViewController: DPCenterContentViewController?
  private(set) var drawerState: DPDrawerControllerState = .closed

  private var leftView: UIView?
  private var rightView: DPDropShadowView?
  private var centerView: DPDropShadowView?
  private var tapGestureRecognizer: UITapGestureRecognizer?
  private var panGestureRecognizer: UIPanGestureRecognizer?
  private var panGestureStartLocation: CGPoint?
  private var createdFormStoryboard: Bool = false
  
  func hideStatusBar(_ hide: Bool) {
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    statusBar.isHidden = hide
  }
  
  func config(_ centerContentViewController: DPCenterContentViewController,
              leftViewController: DPLeftMenuViewController?,
              rightMenuViewController: DPRightMenuViewController?) {
    self.centerContentViewController = centerContentViewController
    self.leftMenuViewController = leftViewController
    self.rightMenuViewController = rightMenuViewController
    self.basicUI()
  }
  
  func basicUI() {
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    leftView = UIView(frame: view.bounds)
    rightView = DPDropShadowView(frame: view.bounds)
    
    centerView = DPDropShadowView(frame: view.bounds)
    leftView?.autoresizingMask = view.autoresizingMask
    rightView?.autoresizingMask = view.autoresizingMask
    centerView?.autoresizingMask = view.autoresizingMask
    
    // Add the center view container
    view.addSubview(centerView!)
    
    // Add the center view controller to the container
    addCenterViewController()
    setupGestureRecognizers()
  }
  
  func addCenterViewController() {
    if let centerViewController = centerContentViewController {
      addChild(centerViewController)
      centerViewController.view.frame = view.bounds
      centerView?.addSubview(centerViewController.view)
      centerViewController.didMove(toParent: self)
    }
  }

  // MARK: Layout
  override public var childForStatusBarHidden :UIViewController {
    if drawerState == .leftOpening {
      return leftMenuViewController!
    }
    if drawerState == .rightOpening {
      return rightMenuViewController!
    }
    return centerContentViewController!
  }
  
  override public var childForStatusBarStyle :UIViewController {
    if drawerState == .leftOpening {
      return leftMenuViewController!
    }
    if drawerState == .rightOpening {
      return rightMenuViewController!
    }
    return centerContentViewController!
  }
  
  // MARK: Gestures
  func setupGestureRecognizers() {
    tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                  action: #selector(tapGestureRecognized(_:)))
    panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                  action: #selector(panGestureRecognized(_:)))
    panGestureRecognizer?.maximumNumberOfTouches = 1
    panGestureRecognizer?.delegate = self
    centerView?.addGestureRecognizer(panGestureRecognizer!)
  }
  
  func addClosingGestureRecognizers() {
    if let tapGestureRecognizer = tapGestureRecognizer {
      centerView?.addGestureRecognizer(tapGestureRecognizer)
    }
  }

  func removeClosingGestureRecognizers() {
    if let tapGestureRecognizer = tapGestureRecognizer {
      centerView?.removeGestureRecognizer(tapGestureRecognizer)
    }
  }
  
  @objc func tapGestureRecognized(_ tapGestureRecognizer: UITapGestureRecognizer) {
    if (tapGestureRecognizer.state == .ended) {
      if drawerState == .leftOpen {
        leftClose()
      }
      if drawerState == .rightOpen {
        rightClose()
      }
    }
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity: CGPoint? = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view)
    if self.drawerState == .closed {
      return true
    } else if self.drawerState == .leftOpen,
      let velocityX = velocity?.x, velocityX < CGFloat(0.0) { // rightWillOpen
      return true
    } else if self.drawerState == .rightOpen,
      let velocityX = velocity?.x, velocityX > CGFloat(0.0) { // leftWillOpen
      return true
    }
    return false
  }
  
  @objc func panGestureRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let state: UIGestureRecognizer.State = panGestureRecognizer.state
    let location: CGPoint = panGestureRecognizer.location(in: view)
    let velocity: CGPoint = panGestureRecognizer.velocity(in: view)
    let velocitX = velocity.x
    
    switch state {
    case .began:
      panGestureStartLocation = location
      if drawerState == .closed {
        if velocitX < -kDPGestureSensitivityValue {
          rightWillOpen()
        }
        if velocitX > kDPGestureSensitivityValue {
          leftWillOpen()
        }
      } else {
        if drawerState == .leftOpen {
          leftWillClose()
        }
        if drawerState == .rightOpen {
          rightWillClose()
        }
      }
      break
    case .changed:
      if drawerState == .leftOpening || drawerState == .leftClosing {
        var delta: CGFloat = 0.0
        if drawerState == .leftOpening {
          delta = location.x - panGestureStartLocation!.x
        } else if drawerState == .leftClosing {
          delta = (UIScreen.main.bounds.width
            - kDPDrawerControllerDrawerWidthGapOffset)
            - (panGestureStartLocation!.x - location.x)
        }
        var leftFrame: CGRect? = leftView!.frame
        var centerFrame: CGRect? = centerView!.frame
        
        if delta > (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset) {
          leftFrame!.origin.x = 0.0
          centerFrame!.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
        } else if delta < 0.0 {
          leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
          centerFrame!.origin.x = 0.0
        } else {
          // parallax effect
          leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
            - (delta * kDPDrawerControllerLeftViewInitialOffset)
            / (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset)
          centerFrame!.origin.x = delta
        }
        leftView!.frame = leftFrame!
        centerView!.frame = centerFrame!
      }
      if drawerState == .rightOpening || drawerState == .rightClosing {
        if drawerState == .rightOpening {
          let delta: CGFloat = panGestureStartLocation!.x - location.x
          let positiveDelta = (delta >= 0) ? delta : 0
          var rightFrame: CGRect? = rightView!.frame
          rightFrame!.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset - positiveDelta
          rightView!.frame = rightFrame!
        } else if drawerState == .rightClosing {
          let delta: CGFloat = location.x - panGestureStartLocation!.x
          let positiveDelta = (delta >= 0) ? delta : 0
          var rightFrame: CGRect? = rightView!.frame
          rightFrame!.origin.x = kDPDrawerControllerDrawerWidthGapOffset + positiveDelta
          rightView!.frame = rightFrame!
        }
      }
      break
    case .ended:
      if drawerState == .leftOpening {
        let centerViewLocationX: CGFloat = centerView!.frame.origin.x
        if centerViewLocationX == (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset) {
          leftDidOpen()
        } else if (centerViewLocationX > view.bounds.size.width / 3.0 && velocity.x > 0.0) {
          self.leftOpening(animated: true)
        } else {
          leftDidOpen()
          leftWillClose()
          leftClosing(animated: true)
        }
      } else if drawerState == .leftClosing {
        let centerViewLocationX: CGFloat = centerView!.frame.origin.x
        if centerViewLocationX == 0.0 {
          // Close the drawer without animation, as it has already being dragged in its final position
          leftDidClose()
        } else if centerViewLocationX < (2 * view.bounds.size.width) / 3.0, velocity.x < 0.0 {
          leftClosing(animated: true)
        } else {
          leftDidClose()
          let leftFrame: CGRect = leftView!.frame
          leftWillOpen()
          leftView!.frame = leftFrame
          leftOpening(animated: true)
        }
      }
      
      if drawerState == .rightOpening {
        let rightViewLocationX: CGFloat = rightView!.frame.origin.x
        if rightViewLocationX == kDPDrawerControllerDrawerWidthGapOffset {
          rightDidOpen()
        } else if (rightViewLocationX < (2 * view.bounds.size.width) / 3.0
          && velocity.x < 0.0) {
          rightOpening(animated: true)
        } else {
          rightDidOpen()
          rightWillClose()
          rightClosing(animated: true)
        }
      } else if drawerState == .rightClosing {
        let rightViewLocationX: CGFloat = rightView!.frame.origin.x
        if rightViewLocationX == view.bounds.width {
          // Close the drawer without animation, as it has already being dragged in its final position
          rightDidClose()
        } else if (rightViewLocationX > view.bounds.size.width / 3.0
          && velocity.x > 0.0) {
          rightClosing(animated: true)
        } else {
          rightDidClose()
          let rightFrame: CGRect = rightView!.frame
          rightWillOpen()
          rightView!.frame = rightFrame
          rightOpening(animated: true)
        }
      }
      break
    default:
      break
    }
  }

  // MARK: Animations
  func leftOpening(animated: Bool) {
    let leftViewFinalFrame: CGRect = view.bounds
    var centerViewFinalFrame: CGRect = view.bounds
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
      }) { (finished) in
        self.leftDidOpen()
      }
    } else {
      centerView!.frame = centerViewFinalFrame
      leftView!.frame = leftViewFinalFrame
      leftDidOpen()
    }
  }
  
  func rightOpening(animated: Bool) {
    var rightViewFinalFrame: CGRect = view.bounds
    rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerOpeningAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerOpeningAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView!.frame = rightViewFinalFrame
      }) { (finished) in
        self.rightDidOpen()
      }
    } else {
      rightView!.frame = rightViewFinalFrame
      rightDidOpen()
    }
  }
  
  func leftClosing(animated: Bool) {
    var leftViewFinalFrame: CGRect = leftView!.frame
    leftViewFinalFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    let centerViewFinalFrame: CGRect = view.bounds
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.centerView!.frame = centerViewFinalFrame
                      self.leftView!.frame = leftViewFinalFrame
      }) { (finished) in
        self.leftDidClose()
      }
    } else {
      centerView!.frame = centerViewFinalFrame
      leftView!.frame = leftViewFinalFrame
      leftDidClose()
    }
  }
  
  func rightClosing(animated: Bool) {
    var rightViewFinalFrame: CGRect = rightView!.frame
    rightViewFinalFrame.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView!.frame = rightViewFinalFrame
      }) { (finished) in
        self.rightDidClose()
      }
    } else {
      rightView!.frame = rightViewFinalFrame
      rightDidClose()
    }
  }
  
  // MARK: Opening the drawer
  func leftOpen() {
    leftWillOpen()
    leftOpening(animated: true)
  }
  
  func rightOpen() {
    rightWillOpen()
    rightOpening(animated: true)
  }

  func leftWillOpen() {
    guard leftMenuViewController != nil else { return }
    hideStatusBar(true)
    drawerState = .leftOpening
    
    // Position the left view
    var frame: CGRect = view.bounds
    frame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    leftView!.frame = frame
    
    // Start adding the left view controller to the container
    guard let leftMenuViewController = self.leftMenuViewController else { return }
    addChild(leftMenuViewController)
    leftMenuViewController.view.frame = leftView!.bounds
    leftView!.addSubview(leftMenuViewController.view)
    
    // Add the left view to the view hierarchy
    view.insertSubview(leftView!,
                       belowSubview: centerView!)
    
    // Notify the child view controllers that the drawer is about to open
    leftMenuViewController.drawerControllerWillOpen?()
    centerContentViewController?.drawerControllerWillOpen?(true)
  }
  
  func rightWillOpen() {
    hideStatusBar(true)
    drawerState = .rightOpening
    
    // Position the right view
    var frame: CGRect = view.bounds
    frame.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    rightView!.frame = frame
    
    // Start adding the right view controller to the container
    guard let rightMenuViewController = self.rightMenuViewController else { return }
    addChild(rightMenuViewController)
    rightMenuViewController.view.frame = rightView!.bounds
    rightView!.addSubview(rightMenuViewController.view)
    
    // Add the right view to the view hierarchy
    view.insertSubview(rightView!,
                       aboveSubview: centerView!)
    
    // Notify the child view controllers that the drawer is about to open
    rightMenuViewController.drawerControllerWillOpen?()
    centerContentViewController?.drawerControllerWillOpen?(false)
  }
  
  func leftDidOpen() {
    // Complete adding the left controller to the container
    leftMenuViewController?.didMove(toParent: self)
    addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    drawerState = .leftOpen
    
    // Notify the child view controllers that the drawer is open
    leftMenuViewController?.drawerControllerDidOpen?()
    centerContentViewController?.drawerControllerDidOpen?(true)
  }
  
  func rightDidOpen() {
    // Complete adding the left controller to the container
    rightMenuViewController?.didMove(toParent: self)
    addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    drawerState = .rightOpen
    
    // Notify the child view controllers that the drawer is open
    rightMenuViewController?.drawerControllerDidOpen?()
    centerContentViewController?.drawerControllerDidOpen?(false)
  }
  
  func leftClose() {
    leftWillClose()
    leftClosing(animated: true)
  }
  
  func rightClose() {
    rightWillClose()
    rightClosing(animated: true)
  }
  
  func leftWillClose() {
    // Start removing the left controller from the container
    leftMenuViewController?.willMove(toParent: nil)
    
    // Keep track that the drawer is closing
    drawerState = .leftClosing
    
    // Notify the child view controllers that the drawer is about to close
    leftMenuViewController?.drawerControllerWillClose?()
    centerContentViewController?.drawerControllerWillClose?(true)
  }
  
  func rightWillClose() {
    // Start removing the left controller from the container
    rightMenuViewController?.willMove(toParent: nil)
    
    // Keep track that the drawer is closing
    drawerState = .rightClosing
    
    // Notify the child view controllers that the drawer is about to close
    rightMenuViewController?.drawerControllerWillClose?()
    centerContentViewController?.drawerControllerWillClose?(false)
  }

  func leftDidClose() {
    hideStatusBar(false)

    // Complete removing the left view controller from the container
    leftMenuViewController?.view.removeFromSuperview()
    leftMenuViewController?.removeFromParent()

    // Remove the left view from the view hierarchy
    leftView?.removeFromSuperview()
    removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    drawerState = .closed

    // Notify the child view controllers that the drawer is closed
    leftMenuViewController?.drawerControllerDidClose?()
    centerContentViewController?.drawerControllerDidClose?(true)
  }
  
  func rightDidClose() {
    hideStatusBar(false)

    // Complete removing the left view controller from the container
    rightMenuViewController?.view.removeFromSuperview()
    rightMenuViewController?.removeFromParent()
    
    // Remove the left view from the view hierarchy
    rightView?.removeFromSuperview()
    removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    drawerState = .closed
    
    // Notify the child view controllers that the drawer is closed
    rightMenuViewController?.drawerControllerDidClose?()
    centerContentViewController?.drawerControllerDidClose?(false)
  }

  func leftResetViewPosition(state: DPDrawerControllerState) {
    if state == .leftOpen {
      let leftViewFinalFrame: CGRect = view.bounds
      var centerViewFinalFrame: CGRect = view.bounds
      centerViewFinalFrame.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
      centerView!.frame = centerViewFinalFrame
      leftView!.frame = leftViewFinalFrame
    }
    if state == .closed {
      //
    }
  }
  
  func rightResetViewPosition(state: DPDrawerControllerState) {
    if state == .leftOpen {
      var rightViewFinalFrame: CGRect = view.bounds
      rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
      rightView!.frame = rightViewFinalFrame
    }
    if state == .closed {
      //
    }
  }

  // MARK: Reloading / Replacing the center view controller
  func leftMenuReloadCenterViewControllerUsingBlock(_ reloadBlock: (()->Void)?) {
    leftWillClose()
    var frame: CGRect = centerView!.frame
    frame.origin.x = view.bounds.size.width
    UIView .animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0, animations: {
      self.centerView!.frame = frame
      }, completion: { (finished) in
        // The center view controller is now out of sight
        reloadBlock?()
        self.leftClosing(animated: true)
    }) 
  }
  
  func rightMenuReloadCenterViewControllerUsingBlock(_ reloadBlock: (()->Void)?) {
    rightWillClose()
    var frame: CGRect = centerView!.frame
    frame.origin.x = view.bounds.size.width
    UIView.animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0, animations: {
      self.centerView!.frame = frame
    }, completion: { (finished) in
      // The center view controller is now out of sight
      reloadBlock?()
      self.rightClosing(animated: true)
    })
  }

  func leftMenuReplaceCenterViewControllerWithViewController(_ viewController: DPCenterContentViewController) {
    leftWillClose()
    centerContentViewController?.willMove(toParent: nil)
    DPSlideMenuManager.shared.setDrawer(drawer: nil)
    centerContentViewController?.view.removeFromSuperview()
    centerContentViewController?.removeFromParent()
    
    // Set the new center view controller
    centerContentViewController = viewController
    DPSlideMenuManager.shared.setDrawer(drawer: self)
    
    // Add the new center view controller to the container
    addCenterViewController()
    
    // Finally, close the drawer
    leftClosing(animated: true)
  }
  
  func rightMenuReplaceCenterViewControllerWithViewController(_ viewController: DPCenterContentViewController) {
    rightWillClose()
    centerContentViewController?.willMove(toParent: nil)
    DPSlideMenuManager.shared.setDrawer(drawer: nil)
    centerContentViewController?.view.removeFromSuperview()
    centerContentViewController?.removeFromParent()
    
    // Set the new center view controller
    centerContentViewController = viewController
    DPSlideMenuManager.shared.setDrawer(drawer: self)
    
    // Add the new center view controller to the container
    addCenterViewController()
    
    // Finally, close the drawer
    rightClosing(animated: true)
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
