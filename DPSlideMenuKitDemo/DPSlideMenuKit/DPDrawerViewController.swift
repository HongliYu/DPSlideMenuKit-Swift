//
//  DPDrawerViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

public class DPDrawerViewController: UIViewController, UIGestureRecognizerDelegate {

  // Controller
  private var leftMenuViewController: DPLeftMenuViewController?
  private var rightMenuViewController: DPRightMenuViewController?
  private var centerContentViewController: DPCenterContentViewController?

  // State
  private(set) var drawerState: DrawerControllerState = .closed

  // View
  private lazy var leftView: UIView = {
    UIView(frame: view.bounds)
  }()
  private lazy var rightView: DPDropShadowView = {
    DPDropShadowView(frame: view.bounds)
  }()
  private lazy var centerView: DPDropShadowView = {
    DPDropShadowView(frame: self.view.bounds)
  }()

  // Gesture, make sure self is initialized before being binded to a gesture
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
  }()
  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
  }()
  private var panGestureStartLocation = CGPoint.zero

  // Status bar
  private var statusBarHidden = false {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }
  open override var prefersStatusBarHidden: Bool {
    return statusBarHidden
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
    leftView.autoresizingMask = view.autoresizingMask
    rightView.autoresizingMask = view.autoresizingMask
    centerView.autoresizingMask = view.autoresizingMask
    
    // Add the center view container
    view.addSubview(centerView)
    
    // Add the center view controller to the container
    addCenterViewController()
    setupGestureRecognizers()
  }
  
  func addCenterViewController() {
    guard let centerContentViewController = centerContentViewController else { return }
    addChild(centerContentViewController)
    centerContentViewController.view.frame = view.bounds
    centerView.addSubview(centerContentViewController.view)
    centerContentViewController.didMove(toParent: self)
  }

  // MARK: Gestures
  func setupGestureRecognizers() {
    panGestureRecognizer.maximumNumberOfTouches = 1
    panGestureRecognizer.delegate = self
    centerView.addGestureRecognizer(panGestureRecognizer)
  }
  
  func addClosingGestureRecognizers() {
    centerView.addGestureRecognizer(tapGestureRecognizer)
  }

  func removeClosingGestureRecognizers() {
    centerView.removeGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func tapGestureRecognized(_ tapGestureRecognizer: UITapGestureRecognizer) {
    if (tapGestureRecognizer.state == .ended) {
      switch drawerState {
      case .leftOpen:
        leftClose()
      case .rightOpen:
        rightClose()
      default: break
      }
    }
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let velocity = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view) else {
      return false
    }
    let velocityX = velocity.x
    switch drawerState {
    case .closed :
      return true
    case .leftOpen:
      return velocityX < CGFloat(0.0) // rightWillOpen
    case .rightOpen:
      return velocityX > CGFloat(0.0) // leftWillOpen
    default:
      return false
    }
  }
  
  @objc func panGestureRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let state = panGestureRecognizer.state
    let location = panGestureRecognizer.location(in: view)
    let velocity = panGestureRecognizer.velocity(in: view)
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
    case .changed:
      if drawerState == .leftOpening || drawerState == .leftClosing {
        var delta: CGFloat = 0.0
        if drawerState == .leftOpening {
          delta = location.x - panGestureStartLocation.x
        } else if drawerState == .leftClosing {
          delta = (UIScreen.main.bounds.width
            - kDPDrawerControllerDrawerWidthGapOffset)
            - (panGestureStartLocation.x - location.x)
        }
        var leftFrame = leftView.frame
        var centerFrame = centerView.frame
        
        if delta > (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset) {
          leftFrame.origin.x = 0.0
          centerFrame.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
        } else if delta < 0.0 {
          leftFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
          centerFrame.origin.x = 0.0
        } else {
          // parallax effect
          leftFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
            - (delta * kDPDrawerControllerLeftViewInitialOffset)
            / (UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset)
          centerFrame.origin.x = delta
        }
        leftView.frame = leftFrame
        centerView.frame = centerFrame
      }
      if drawerState == .rightOpening || drawerState == .rightClosing {
        if drawerState == .rightOpening {
          let delta: CGFloat = panGestureStartLocation.x - location.x
          let positiveDelta = (delta >= 0) ? delta : 0
          var rightFrame = rightView.frame
          rightFrame.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset - positiveDelta
          rightView.frame = rightFrame
        } else if drawerState == .rightClosing {
          let delta: CGFloat = location.x - panGestureStartLocation.x
          let positiveDelta = (delta >= 0) ? delta : 0
          var rightFrame = rightView.frame
          rightFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset + positiveDelta
          rightView.frame = rightFrame
        }
      }
    case .ended:
      if drawerState == .leftOpening {
        let centerViewLocationX: CGFloat = centerView.frame.origin.x
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
        let centerViewLocationX: CGFloat = centerView.frame.origin.x
        if centerViewLocationX == 0.0 {
          // Close the drawer without animation, as it has already being dragged in its final position
          leftDidClose()
        } else if centerViewLocationX < (2 * view.bounds.size.width) / 3.0, velocity.x < 0.0 {
          leftClosing(animated: true)
        } else {
          leftDidClose()
          let leftFrame: CGRect = leftView.frame
          leftWillOpen()
          leftView.frame = leftFrame
          leftOpening(animated: true)
        }
      }
      
      if drawerState == .rightOpening {
        let rightViewLocationX: CGFloat = rightView.frame.origin.x
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
        let rightViewLocationX: CGFloat = rightView.frame.origin.x
        if rightViewLocationX == view.bounds.width {
          // Close the drawer without animation, as it has already being dragged in its final position
          rightDidClose()
        } else if (rightViewLocationX > view.bounds.size.width / 3.0
          && velocity.x > 0.0) {
          rightClosing(animated: true)
        } else {
          rightDidClose()
          let rightFrame: CGRect = rightView.frame
          rightWillOpen()
          rightView.frame = rightFrame
          rightOpening(animated: true)
        }
      }
    default:
      break
    }
  }

  // MARK: Animations
  private func leftOpening(animated: Bool) {
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
                      self.centerView.frame = centerViewFinalFrame
                      self.leftView.frame = leftViewFinalFrame
      }) { _ in
        self.leftDidOpen()
      }
    } else {
      centerView.frame = centerViewFinalFrame
      leftView.frame = leftViewFinalFrame
      leftDidOpen()
    }
  }
  
  private func rightOpening(animated: Bool) {
    var rightViewFinalFrame: CGRect = view.bounds
    rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerOpeningAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerOpeningAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView.frame = rightViewFinalFrame
      }) { _ in
        self.rightDidOpen()
      }
    } else {
      rightView.frame = rightViewFinalFrame
      rightDidOpen()
    }
  }
  
  private func leftClosing(animated: Bool) {
    var leftViewFinalFrame: CGRect = leftView.frame
    leftViewFinalFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    let centerViewFinalFrame: CGRect = view.bounds
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.centerView.frame = centerViewFinalFrame
                      self.leftView.frame = leftViewFinalFrame
      }) { _ in
        self.leftDidClose()
      }
    } else {
      centerView.frame = centerViewFinalFrame
      leftView.frame = leftViewFinalFrame
      leftDidClose()
    }
  }
  
  private func rightClosing(animated: Bool) {
    var rightViewFinalFrame: CGRect = rightView.frame
    rightViewFinalFrame.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    if animated {
      UIView.animate(withDuration: kDPDrawerControllerAnimationDuration,
                     delay: 0,
                     usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                     initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                     options: .curveLinear,
                     animations: {
                      self.rightView.frame = rightViewFinalFrame
      }) { _ in
        self.rightDidClose()
      }
    } else {
      rightView.frame = rightViewFinalFrame
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

  private func leftWillOpen() {
    guard let leftMenuViewController = self.leftMenuViewController else { return }
    statusBarHidden = true
    drawerState = .leftOpening

    // Position the left view
    var frame: CGRect = view.bounds
    frame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    leftView.frame = frame

    // Start adding the left view controller to the container
    addChild(leftMenuViewController)
    leftMenuViewController.view.frame = leftView.bounds
    leftView.addSubview(leftMenuViewController.view)

    // Add the left view to the view hierarchy
    view.insertSubview(leftView,
                       belowSubview: centerView)

    // Notify the child view controllers that the drawer is about to open
    leftMenuViewController.drawerControllerWillOpen?()
    centerContentViewController?.drawerControllerWillOpen?(true)
  }
  
  private func rightWillOpen() {
    guard let rightMenuViewController = self.rightMenuViewController else { return }
    statusBarHidden = true
    drawerState = .rightOpening
    
    // Position the right view
    var frame = view.bounds
    frame.origin.x = view.bounds.width + kDPDrawerControllerDrawerWidthGapOffset
    rightView.frame = frame
    
    // Start adding the right view controller to the container
    addChild(rightMenuViewController)
    rightMenuViewController.view.frame = rightView.bounds
    rightView.addSubview(rightMenuViewController.view)
    
    // Add the right view to the view hierarchy
    view.insertSubview(rightView, aboveSubview: centerView)
    
    // Notify the child view controllers that the drawer is about to open
    rightMenuViewController.drawerControllerWillOpen?()
    centerContentViewController?.drawerControllerWillOpen?(false)
  }
  
  private func leftDidOpen() {
    // Complete adding the left controller to the container
    leftMenuViewController?.didMove(toParent: self)
    addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    drawerState = .leftOpen
    
    // Notify the child view controllers that the drawer is open
    leftMenuViewController?.drawerControllerDidOpen?()
    centerContentViewController?.drawerControllerDidOpen?(true)
  }
  
  private func rightDidOpen() {
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
  
  private func leftWillClose() {
    // Start removing the left controller from the container
    leftMenuViewController?.willMove(toParent: nil)
    
    // Keep track that the drawer is closing
    drawerState = .leftClosing
    
    // Notify the child view controllers that the drawer is about to close
    leftMenuViewController?.drawerControllerWillClose?()
    centerContentViewController?.drawerControllerWillClose?(true)
  }
  
  private func rightWillClose() {
    // Start removing the left controller from the container
    rightMenuViewController?.willMove(toParent: nil)
    
    // Keep track that the drawer is closing
    drawerState = .rightClosing
    
    // Notify the child view controllers that the drawer is about to close
    rightMenuViewController?.drawerControllerWillClose?()
    centerContentViewController?.drawerControllerWillClose?(false)
  }

  private func leftDidClose() {
    statusBarHidden = false

    // Complete removing the left view controller from the container
    leftMenuViewController?.view.removeFromSuperview()
    leftMenuViewController?.removeFromParent()

    // Remove the left view from the view hierarchy
    leftView.removeFromSuperview()
    removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    drawerState = .closed

    // Notify the child view controllers that the drawer is closed
    leftMenuViewController?.drawerControllerDidClose?()
    centerContentViewController?.drawerControllerDidClose?(true)
  }
  
  private func rightDidClose() {
    statusBarHidden = false

    // Complete removing the left view controller from the container
    rightMenuViewController?.view.removeFromSuperview()
    rightMenuViewController?.removeFromParent()
    
    // Remove the left view from the view hierarchy
    rightView.removeFromSuperview()
    removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    drawerState = .closed
    
    // Notify the child view controllers that the drawer is closed
    rightMenuViewController?.drawerControllerDidClose?()
    centerContentViewController?.drawerControllerDidClose?(false)
  }

  // MARK: Reloading / Replacing the center view controller
  func leftMenuReloadCenterViewController(_ done: (()->Void)?) {
    leftWillClose()
    var frame = centerView.frame
    frame.origin.x = view.bounds.size.width
    UIView.animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0, animations: {
      self.centerView.frame = frame
    }, completion: { _ in
      done?()
      self.leftClosing(animated: true)
    })
  }
  
  func rightMenuReloadCenterViewController(_ done: (()->Void)?) {
    rightWillClose()
    var frame = centerView.frame
    frame.origin.x = view.bounds.size.width
    UIView.animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0, animations: {
      self.centerView.frame = frame
    }, completion: { _ in
      done?()
      self.rightClosing(animated: true)
    })
  }

  private func resetCenterViewController(_ viewController: DPCenterContentViewController) {
    centerContentViewController?.willMove(toParent: nil)
    DPSlideMenuManager.shared.setDrawer(drawer: nil)
    centerContentViewController?.view.removeFromSuperview()
    centerContentViewController?.removeFromParent()

    // Set the new center view controller
    centerContentViewController = viewController
    DPSlideMenuManager.shared.setDrawer(drawer: self)

    // Add the new center view controller to the container
    addCenterViewController()
  }

  func replaceCenterViewController(_ centerContentViewController: DPCenterContentViewController,
                                   menuPosition: MenuPosition) {
    switch menuPosition {
    case .left:
      leftWillClose()
      resetCenterViewController(centerContentViewController)
      leftClosing(animated: true)
    case .right:
      rightWillClose()
      resetCenterViewController(centerContentViewController)
      rightClosing(animated: true)
    }
  }

  // MARK: Screen rotation
  override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil) { _ in
      switch self.drawerState {
        case .leftOpen:
          self.leftResetViewPosition(state: .leftOpen)
        case .rightOpen:
          self.rightResetViewPosition(state: .rightOpen)
        case .closed:
          self.leftMenuViewController?.resetUI()
          self.rightMenuViewController?.resetUI()
      default:
        break
      }
    }
  }

  private func leftResetViewPosition(state: DrawerControllerState) {
    guard state == .leftOpen else { return }
    let leftViewFinalFrame = view.bounds
    var centerViewFinalFrame = view.bounds
    centerViewFinalFrame.origin.x = UIScreen.main.bounds.width - kDPDrawerControllerDrawerWidthGapOffset
    centerView.frame = centerViewFinalFrame
    leftView.frame = leftViewFinalFrame
  }

  private func rightResetViewPosition(state: DrawerControllerState) {
    guard state == .rightOpen else { return }
    var rightViewFinalFrame = view.bounds
    rightViewFinalFrame.origin.x = kDPDrawerControllerDrawerWidthGapOffset
    rightView.frame = rightViewFinalFrame
  }

}
