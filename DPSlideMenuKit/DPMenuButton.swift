//
//  DPMenuButton.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/23/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: Constant
let animateDuration : Double = 0.3
let animateDelay: Double = 0.05

// MARK: Extension
extension CALayer {
  func applyAnimation(_ animation: CABasicAnimation) {
    let copy = animation.copy() as! CABasicAnimation
    if copy.fromValue == nil {
      copy.fromValue = self.presentation()!.value(forKeyPath: copy.keyPath!)
    }
    self.add(copy, forKey: copy.keyPath)
    self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
  }
}

class DPMenuButton: UIButton {
  
  let topLayer = CAShapeLayer()
  let midLayer = CAShapeLayer()
  let bottomLayer = CAShapeLayer()
  let sideLayer = CAShapeLayer()

  var menuPath : CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint.init(x: thickness / 2.0, y: thickness / 2.0))
    path.addLine(to: CGPoint.init(x: lineWidth - thickness / 2.0, y: thickness / 2.0))
    return path
  }
  
  var sidePath: CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint.init(x: 0, y: self.bounds.height / 2.0))
    path.addLine(to: CGPoint.init(x: self.bounds.width, y: self.bounds.height / 2.0))
    return path
  }
  
  override var isSelected: Bool {
    didSet {
      self.showMenu(self.isSelected)
    }
  }

  @IBInspectable var lineWidth : CGFloat = 28.0 {
    didSet {
      self.updateSubLayers()
    }
  }
  
  @IBInspectable var thickness : CGFloat = 4.0 {
    didSet {
      self.updateSubLayers()
    }
  }
  
  @IBInspectable var lineMargin : CGFloat = 10.0 {
    didSet {
      self.updateSubLayers()
    }
  }
  
  @IBInspectable var lineCapRound : Bool = true {
    didSet {
      self.updateSubLayers()
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var strokeColor : UIColor = UIColor.white {
    didSet {
      self.updateSubLayers()
    }
  }
  
  @IBInspectable var sideLayerStrokeColor : UIColor = UIColor.clear {
    didSet {
      self.updateSubLayers()
    }
  }

  @IBInspectable var slideLeftToRight : Bool = true {
    didSet {
      if slideLeftToRight {
        sideLayer.strokeStart = 0.0
        sideLayer.strokeEnd = 0.0
      } else {
        sideLayer.strokeStart = 1.0
        sideLayer.strokeEnd = 1.0
      }
    }
  }
  
  // MARK: Life Cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  func setup() {
    sideLayer.opacity = 0.2
    if slideLeftToRight {
      sideLayer.strokeStart = 0.0
      sideLayer.strokeEnd = 0.0
    } else {
      sideLayer.strokeStart = 1.0
      sideLayer.strokeEnd = 1.0
    }
    for layer in [sideLayer, topLayer, midLayer, bottomLayer] {
      layer.masksToBounds = true
      layer.actions = [
        "strokeStart": NSNull(),
        "strokeEnd": NSNull(),
      ]
      self.layer.addSublayer(layer)
    }
    self.layer.masksToBounds = true
    self.updateSubLayers()
  }

  // MARK: Animation
  func showMenu(_ isShow: Bool) {
    if isShow {
      let sideAnim = CABasicAnimation(keyPath: slideLeftToRight ? "strokeEnd" : "strokeStart")
      sideAnim.duration = animateDuration - 0.1
      sideAnim.beginTime = CACurrentMediaTime() + 0.1
      sideAnim.toValue = slideLeftToRight ? 0.6 : 0.4
      sideAnim.fillMode = kCAFillModeBackwards
      sideLayer.applyAnimation(sideAnim)
      
      for (idx, layer) in [topLayer, midLayer, bottomLayer].enumerated() {
        let anim = CABasicAnimation(keyPath: slideLeftToRight ? "strokeEnd" : "strokeStart")
        anim.toValue = slideLeftToRight ? 0.3 : 0.7
        anim.duration = animateDuration
        anim.fillMode = kCAFillModeBackwards
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.beginTime = CACurrentMediaTime() + Double(idx) * animateDelay
        layer.applyAnimation(anim)
      }
    } else {
      let sideAnim = CABasicAnimation(keyPath: slideLeftToRight ? "strokeEnd" : "strokeStart")
      sideAnim.duration = animateDuration - 0.1
      sideAnim.beginTime = CACurrentMediaTime() + 0.1
      sideAnim.toValue = slideLeftToRight ? 0.0 : 1.0
      sideAnim.fillMode = kCAFillModeBackwards
      sideLayer.applyAnimation(sideAnim)
      
      for (idx, layer) in [topLayer, midLayer, bottomLayer].enumerated() {
        let anim = CABasicAnimation(keyPath: slideLeftToRight ? "strokeEnd" : "strokeStart")
        anim.toValue = slideLeftToRight ? 1.0 : 0.0
        anim.duration = animateDuration
        anim.fillMode = kCAFillModeBackwards
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.beginTime = CACurrentMediaTime() + Double(idx) * animateDelay
        layer.applyAnimation(anim)
      }
    }
  }
  
  func updateSubLayers() {
    let path = self.menuPath
    let strokingPath = CGPath(__byStroking: path, transform: nil, lineWidth: thickness, lineCap: CGLineCap.round, lineJoin: CGLineJoin.miter, miterLimit: 10)
    let bounds = strokingPath?.boundingBoxOfPath
    sideLayer.strokeColor = self.sideLayerStrokeColor.cgColor
    for layer in [topLayer, midLayer, bottomLayer] {
      layer.path = path
      layer.bounds = bounds!
      layer.strokeColor = self.strokeColor.cgColor
      layer.lineWidth = thickness
      layer.lineCap = lineCapRound ? kCALineCapRound : kCALineCapSquare
    }
    self.setNeedsLayout()
  }
  
  override func layoutSubviews() {
    let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    self.midLayer.position = center
    self.topLayer.position = CGPoint(x: center.x, y: center.y - lineMargin)
    self.bottomLayer.position = CGPoint(x: center.x, y: center.y + lineMargin)
    sideLayer.bounds = self.bounds
    sideLayer.path = sidePath
    sideLayer.lineWidth = self.bounds.height
    sideLayer.position = center
  }
  
}
