//
//  DPDrawerViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

// MARK: Enum
public enum DPDrawerControllerState: Int {
  case DPDrawerControllerStateClosed = 0
  case DPDrawerControllerStateOpening
  case DPDrawerControllerStateOpen
  case DPDrawerControllerStateClosing

  var description: String {
    switch self {
    case .DPDrawerControllerStateClosed:
      return "DPDrawerControllerStateClosed"
    case .DPDrawerControllerStateOpening:
      return "DPDrawerControllerStateOpening"
    case .DPDrawerControllerStateOpen:
      return "DPDrawerControllerStateOpen"
    case .DPDrawerControllerStateClosing:
      return "DPDrawerControllerStateClosing"
    }
  }
}

// MARK: Constant
let kDPDrawerControllerDrawerDepth: CGFloat = 260.0
let kDPDrawerControllerLeftViewInitialOffset: CGFloat = -60.0
let kDPDrawerControllerAnimationDuration: NSTimeInterval = 0.5
let kDPDrawerControllerOpeningAnimationSpringDamping: CGFloat = 0.7
let kDPDrawerControllerOpeningAnimationSpringInitialVelocity: CGFloat = 0.1
let kDPDrawerControllerClosingAnimationSpringDamping: CGFloat = 1.0
let kDPDrawerControllerClosingAnimationSpringInitialVelocity: CGFloat = 0.5

public class DPDrawerViewController: UIViewController, UIGestureRecognizerDelegate {
  
  private(set) public var leftMenuViewController: DPLeftMenuViewController?
  private(set) public var centerViewController: DPContentViewController?
  private(set) public var drawerState: DPDrawerControllerState = .DPDrawerControllerStateClosed

  private var leftView: UIView?
  private var centerView: DPDropShadowView?
  private var tapGestureRecognizer: UITapGestureRecognizer?
  private var panGestureRecognizer: UIPanGestureRecognizer?
  private var panGestureStartLocation: CGPoint?
  
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
    self.basicParamsConfig()
  }
  
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
    self.basicParamsConfig()
  }

  private func basicParamsConfig() { // ensure not crash by direct init...
    self.leftMenuViewController = DPLeftMenuViewController.init(slideMenuModels: nil)
    self.leftMenuViewController?.drawer = self
    self.centerViewController = DPContentViewController.init()
    self.centerViewController?.drawer = self
  }
  
  override public func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
  
  func addCenterViewController() {
    if let centerViewController = self.centerViewController {
      self.addChildViewController(centerViewController)
      centerViewController.view.frame = self.view.bounds
      self.centerView?.addSubview(centerViewController.view)
      centerViewController.didMoveToParentViewController(self)
    }
  }

  // MARK: Layout
  public override func childViewControllerForStatusBarHidden() ->UIViewController {
    if (self.drawerState == .DPDrawerControllerStateOpening) {
      return self.leftMenuViewController!
    }
    return self.centerViewController!
  }
  
  public override func childViewControllerForStatusBarStyle() ->UIViewController {
    if (self.drawerState == .DPDrawerControllerStateOpening) {
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
  
  func tapGestureRecognized(tapGestureRecognizer: UITapGestureRecognizer) {
    if (tapGestureRecognizer.state == .Ended) {
      self.close()
    }
  }
  
  public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity: CGPoint? = (gestureRecognizer as? UIPanGestureRecognizer)?.velocityInView(self.view)
    if self.drawerState == .DPDrawerControllerStateClosed && velocity?.x > 0.0 {
      return true
    } else if self.drawerState == .DPDrawerControllerStateOpen && velocity?.x < 0.0 {
      return true
    }
    return false
  }
  
  func panGestureRecognized(panGestureRecognizer: UIPanGestureRecognizer) {
    let state: UIGestureRecognizerState = panGestureRecognizer.state
    let location: CGPoint = panGestureRecognizer.locationInView(self.view)
    let velocity: CGPoint = panGestureRecognizer.velocityInView(self.view)
    
    switch state {
    case .Began:
      self.panGestureStartLocation = location
      if self.drawerState == .DPDrawerControllerStateClosed {
        self.willOpen()
      } else {
        self.willClose()
      }
      break
    case .Changed:
      var delta: CGFloat = 0.0
      if self.drawerState == .DPDrawerControllerStateOpening {
        delta = location.x - self.panGestureStartLocation!.x
      } else if (self.drawerState == .DPDrawerControllerStateClosing) {
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
    case .Ended:
      if (self.drawerState == .DPDrawerControllerStateOpening) {
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
      } else if (self.drawerState == .DPDrawerControllerStateClosing) {
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
  public func animateOpening() {
    // Calculate the final frames for the container views
    let leftViewFinalFrame: CGRect = self.view.bounds
    var centerViewFinalFrame: CGRect = self.view.bounds
    centerViewFinalFrame.origin.x = kDPDrawerControllerDrawerDepth
    UIView.animateWithDuration(kDPDrawerControllerAnimationDuration,
                               delay: 0,
                               usingSpringWithDamping: kDPDrawerControllerOpeningAnimationSpringDamping,
                               initialSpringVelocity: kDPDrawerControllerOpeningAnimationSpringInitialVelocity,
                               options: .CurveLinear,
                               animations: {
                                self.centerView!.frame = centerViewFinalFrame
                                self.leftView!.frame = leftViewFinalFrame
                                self.setNeedsStatusBarAppearanceUpdate()
    }) { (finished) in
        self.didOpen()
      }
    }
  
  public func animateClosing() {
    // Calculate final frames for the container views
    var leftViewFinalFrame: CGRect = self.leftView!.frame
    leftViewFinalFrame.origin.x = kDPDrawerControllerLeftViewInitialOffset
    let centerViewFinalFrame: CGRect = self.view.bounds
    UIView.animateWithDuration(kDPDrawerControllerAnimationDuration,
                               delay: 0,
                               usingSpringWithDamping: kDPDrawerControllerClosingAnimationSpringDamping,
                               initialSpringVelocity: kDPDrawerControllerClosingAnimationSpringInitialVelocity,
                               options: .CurveLinear,
                               animations: {
                                self.centerView!.frame = centerViewFinalFrame
                                self.leftView!.frame = leftViewFinalFrame
                                self.setNeedsStatusBarAppearanceUpdate()
      }) { (finished) in
          self.didClose()
        }
      }
  
  // MARK: Opening the drawer
  public func open() {
    self.willOpen()
    self.animateOpening()
  }
  
  public func willOpen() {
    // Keep track that the drawer is opening
    self.drawerState = .DPDrawerControllerStateOpening
    
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
  
  public func didOpen() {
    // Complete adding the left controller to the container
    self.leftMenuViewController?.didMoveToParentViewController(self)
    self.addClosingGestureRecognizers()
    
    // Keep track that the drawer is open
    self.drawerState = .DPDrawerControllerStateOpen
    
    // Notify the child view controllers that the drawer is open
    self.leftMenuViewController?.drawerControllerDidOpen?()
    self.centerViewController?.drawerControllerDidOpen?()

  }
  
  public func close() {
    self.willClose()
    self.animateClosing()
  }
  
  public func willClose() {
    // Start removing the left controller from the container
    self.leftMenuViewController?.willMoveToParentViewController(nil)
    
    // Keep track that the drawer is closing
    self.drawerState = .DPDrawerControllerStateClosing
    
    // Notify the child view controllers that the drawer is about to close
    self.leftMenuViewController?.drawerControllerWillClose?()
    self.centerViewController?.drawerControllerWillClose?()
  }
  
  public func didClose() {
    // Complete removing the left view controller from the container
    self.leftMenuViewController?.view.removeFromSuperview()
    self.leftMenuViewController?.removeFromParentViewController()

    // Remove the left view from the view hierarchy
    self.leftView?.removeFromSuperview()
    self.removeClosingGestureRecognizers()
    
    // Keep track that the drawer is closed
    self.drawerState = .DPDrawerControllerStateClosed

    // Notify the child view controllers that the drawer is closed
    self.leftMenuViewController?.drawerControllerDidClose?()
    self.centerViewController?.drawerControllerDidClose?()
  }
  
  // MARK: Reloading / Replacing the center view controller
  public func reloadCenterViewControllerUsingBlock(reloadBlock: (()->Void)?) {
    self.willClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    UIView .animateWithDuration(kDPDrawerControllerAnimationDuration / 2.0,
                                animations: {
                                  self.centerView!.frame = frame
      }) { (finished) in
        // The center view controller is now out of sight
        reloadBlock?()
        self.animateClosing()
    }
  }
  
  public func replaceCenterViewControllerWithViewController(viewController: DPContentViewController) {
    self.willClose()
    var frame: CGRect = self.centerView!.frame
    frame.origin.x = self.view.bounds.size.width
    self.centerViewController?.willMoveToParentViewController(nil)
    UIView .animateWithDuration(kDPDrawerControllerAnimationDuration / 2.0,
                                animations: {
                                  self.centerView!.frame = frame
      }) { (finished) in
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
    }
  }
  
}
