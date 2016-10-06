//
//  DPDrawerViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// MARK: Enum
public enum DPDrawerControllerState: Int {
  case dpDrawerControllerStateClosed = 0
  case dpDrawerControllerStateOpening
  case dpDrawerControllerStateOpen
  case dpDrawerControllerStateClosing

  var description: String {
    switch self {
    case .dpDrawerControllerStateClosed:
      return "DPDrawerControllerStateClosed"
    case .dpDrawerControllerStateOpening:
      return "DPDrawerControllerStateOpening"
    case .dpDrawerControllerStateOpen:
      return "DPDrawerControllerStateOpen"
    case .dpDrawerControllerStateClosing:
      return "DPDrawerControllerStateClosing"
    }
  }
}

// MARK: Constant
let kDPDrawerControllerDrawerDepth: CGFloat = 260.0
let kDPDrawerControllerLeftViewInitialOffset: CGFloat = -60.0
let kDPDrawerControllerAnimationDuration: TimeInterval = 0.5
let kDPDrawerControllerOpeningAnimationSpringDamping: CGFloat = 0.7
let kDPDrawerControllerOpeningAnimationSpringInitialVelocity: CGFloat = 0.1
let kDPDrawerControllerClosingAnimationSpringDamping: CGFloat = 1.0
let kDPDrawerControllerClosingAnimationSpringInitialVelocity: CGFloat = 0.5

open class DPDrawerViewController: UIViewController, UIGestureRecognizerDelegate {
  
  fileprivate(set) open var leftMenuViewController: DPLeftMenuViewController?
  fileprivate(set) open var centerViewController: DPContentViewController?
  fileprivate(set) open var drawerState: DPDrawerControllerState = .dpDrawerControllerStateClosed

  fileprivate var leftView: UIView?
  fileprivate var centerView: DPDropShadowView?
  fileprivate var tapGestureRecognizer: UITapGestureRecognizer?
  fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
  fileprivate var panGestureStartLocation: CGPoint?
  fileprivate var createdFormStoryboard: Bool = false

  // MARK: Life Cycle
  public init(leftViewController aLeftViewController: DPLeftMenuViewController?,
    centerViewController aCenterViewController: DPContentViewController?) {
    super.init(nibName: nil, bundle: nil)
    self.leftMenuViewController = aLeftViewController
    self.leftMenuViewController?.drawer = self
    self.centerViewController = aCenterViewController
    self.centerViewController?.drawer = self
  }
    
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.createdFormStoryboard = true
  }
  
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }

  open func reset(leftViewController aLeftViewController: DPLeftMenuViewController?,
                   centerViewController aCenterViewController: DPContentViewController?) {
    self.leftMenuViewController = aLeftViewController
    self.leftMenuViewController?.drawer = self
    self.centerViewController = aCenterViewController
    self.centerViewController?.drawer = self
    self.createdFormStoryboard = false
    self.basicUIConfig()
  }
  
  open func basicUIConfig() {
    if self.createdFormStoryboard {
      return
    }
    self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.leftView = UIView.init(frame: self.view.bounds)
    self.centerView = DPDropShadowView.init(frame: self.view.bounds)
    self.leftView?.autoresizingMask = self.view.autoresizingMask
    self.centerView?.autoresizingMask = self.view.autoresizingMask
    
    // Add the center view container
    self.view.addSubview(self.centerView!)
    
    // Add the center view controller to the container
    self.addCenterViewController()
    self.setupGestureRecognizers()
  }
  
  override open var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    self.basicUIConfig()
  }
  
  func addCenterViewController() {
    if let centerViewController = self.centerViewController {
      self.addChildViewController(centerViewController)
      centerViewController.view.frame = self.view.bounds
      self.centerView?.addSubview(centerViewController.view)
      centerViewController.didMove(toParentViewController: self)
    }
  }

  // MARK: Layout
  open override var childViewControllerForStatusBarHidden :UIViewController {
    if (self.drawerState == .dpDrawerControllerStateOpening) {
      return self.leftMenuViewController!
    }
    return self.centerViewController!
  }
  
  open override var childViewControllerForStatusBarStyle :UIViewController {
    if (self.drawerState == .dpDrawerControllerStateOpening) {
      return self.leftMenuViewController!
    }
    return self.centerViewController!
  }
  
  // MARK: Gestures
  func setupGestureRecognizers() {
    self.tapGestureRecognizer = UITapGestureRecognizer.init(target: self,
                                                            action: #selector(tapGestureRecognized(_:)))
    self.panGestureRecognizer = UIPanGestureRecognizer.init(target: self,
                                                            action: #selector(panGestureRecognized(_:)))
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
      self.close()
    }
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity: CGPoint? = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: self.view)
    if self.drawerState == .dpDrawerControllerStateClosed && velocity?.x > 0.0 {
      return true
    } else if self.drawerState == .dpDrawerControllerStateOpen && velocity?.x < 0.0 {
      return true
    }
    return false
  }
  
  func panGestureRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let state: UIGestureRecognizerState = panGestureRecognizer.state
    let location: CGPoint = panGestureRecognizer.location(in: self.view)
    let velocity: CGPoint = panGestureRecognizer.velocity(in: self.view)
    
    switch state {
    case .began:
      self.panGestureStartLocation = location
      if self.drawerState == .dpDrawerControllerStateClosed {
        self.willOpen()
      } else {
        self.willClose()
      }
      break
    case .changed:
      var delta: CGFloat = 0.0
      if self.drawerState == .dpDrawerControllerStateOpening {
        delta = location.x - self.panGestureStartLocation!.x
      } else if (self.drawerState == .dpDrawerControllerStateClosing) {
        delta = kDPDrawerControllerDrawerDepth - (self.panGestureStartLocation!.x - location.x)
      }
      var leftFrame: CGRect? = self.leftView!.frame
      var centerFrame: CGRect? = self.centerView!.frame
      
      if (delta > kDPDrawerControllerDrawerDepth) {
        leftFrame!.origin.x = 0.0
        centerFrame!.origin.x = kDPDrawerControllerDrawerDepth
      } else if (delta < 0.0) {
        leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
        centerFrame!.origin.x = 0.0
      } else {
        // parallax effect
        leftFrame!.origin.x = kDPDrawerControllerLeftViewInitialOffset
          - (delta * kDPDrawerControllerLeftViewInitialOffset) / kDPDrawerControllerDrawerDepth
        centerFrame!.origin.x = delta
      }
      self.leftView!.frame = leftFrame!
      self.centerView!.frame = centerFrame!
      break
    case .ended:
      if (self.drawerState == .dpDrawerControllerStateOpening) {
        let centerViewLocation: CGFloat = self.centerView!.frame.origin.x;
        if (centerViewLocation == kDPDrawerControllerDrawerDepth) {
          self.setNeedsStatusBarAppearanceUpdate()
          self.didOpen()
        } else if (centerViewLocation > self.view.bounds.size.width / 3.0
          && velocity.x > 0.0) {
          self.animateOpening()
        } else {
          self.didOpen()
          self.willClose()
          self.animateClosing()
        }
      } else if (self.drawerState == .dpDrawerControllerStateClosing) {
        let centerViewLocation: CGFloat = self.centerView!.frame.origin.x;
        if (centerViewLocation == 0.0) {
          // Close the drawer without animation, as it has already being dragged in its final position
          self.setNeedsStatusBarAppearanceUpdate()
          self.didClose()
        } else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3.0
          && velocity.x < 0.0) {
          self.animateClosing()
        } else {
          self.didClose()
          let leftFrame: CGRect = self.leftView!.frame
          self.willOpen()
          self.leftView!.frame = leftFrame
          self.animateOpening()
        }
      }
      break
    default:
      break
    }
  }

  // MARK: Animations
  open func animateOpening() {
    // Calculate the final frames for the container views
    let leftViewFinalFrame: CGRect = self.view.bounds
    var centerViewFinalFrame: CGRect = self.view.bounds
    centerViewFinalFrame.origin.x = kDPDrawerControllerDrawerDepth
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
        self.didOpen()
      }
    }
  
  open func animateClosing() {
    // Calculate final frames for the container views
    var leftViewFinalFrame: CGRect = self.leftView!.frame
    leftViewFinalFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    let centerViewFinalFrame: CGRect = self.view.bounds
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
          self.didClose()
        }
      }
  
  // MARK: Opening the drawer
  open func open() {
    self.willOpen()
    self.animateOpening()
  }
  
  open func willOpen() {
    // Keep track that the drawer is opening
    self.drawerState = .dpDrawerControllerStateOpening
    
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
    self.centerViewController?.drawerControllerWillOpen?()
  }
  
  open func didOpen() {
    // Complete adding the left controller to the container
    self.leftMenuViewController?.didMove(toParentViewController: self)
    self.addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    self.drawerState = .dpDrawerControllerStateOpen
    
    // Notify the child view controllers that the drawer is open
    self.leftMenuViewController?.drawerControllerDidOpen?()
    self.centerViewController?.drawerControllerDidOpen?()

  }
  
  open func close() {
    self.willClose()
    self.animateClosing()
  }
  
  open func willClose() {
    // Start removing the left controller from the container
    self.leftMenuViewController?.willMove(toParentViewController: nil)
    
    // Keep track that the drawer is closing
    self.drawerState = .dpDrawerControllerStateClosing
    
    // Notify the child view controllers that the drawer is about to close
    self.leftMenuViewController?.drawerControllerWillClose?()
    self.centerViewController?.drawerControllerWillClose?()
  }
  
  open func didClose() {
    // Complete removing the left view controller from the container
    self.leftMenuViewController?.view.removeFromSuperview()
    self.leftMenuViewController?.removeFromParentViewController()

    // Remove the left view from the view hierarchy
    self.leftView?.removeFromSuperview()
    self.removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    self.drawerState = .dpDrawerControllerStateClosed

    // Notify the child view controllers that the drawer is closed
    self.leftMenuViewController?.drawerControllerDidClose?()
    self.centerViewController?.drawerControllerDidClose?()
  }
  
  // MARK: Reloading / Replacing the center view controller
  open func reloadCenterViewControllerUsingBlock(_ reloadBlock: (()->Void)?) {
    self.willClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    UIView .animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0,
                                animations: {
                                  self.centerView!.frame = frame
      }, completion: { (finished) in
        // The center view controller is now out of sight
        reloadBlock?()
        self.animateClosing()
    }) 
  }
  
  open func replaceCenterViewControllerWithViewController(_ viewController: DPContentViewController) {
    self.willClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    self.centerViewController?.willMove(toParentViewController: nil)
    UIView .animate(withDuration: kDPDrawerControllerAnimationDuration / 2.0,
                                animations: {
                                  self.centerView!.frame = frame
      }, completion: { (finished) in
        // The center view controller is now out of sight
        
        // Remove the current center view controller from the container
        self.centerViewController?.drawer = nil
        self.centerViewController?.view.removeFromSuperview()
        self.centerViewController?.removeFromParentViewController()
        
        // Set the new center view controller
        self.centerViewController = viewController
        self.centerViewController?.drawer = self
        
        // Add the new center view controller to the container
        self.addCenterViewController()
        
        // Finally, close the drawer
        self.animateClosing()
    }) 
  }
  
}
