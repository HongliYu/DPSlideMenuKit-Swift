//
//  ViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var drawerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // embed in storyboard
    var drawer: DPDrawerViewController?
    self.childViewControllers.forEach { (viewController) in
      if viewController is DPDrawerViewController {
        drawer = viewController as? DPDrawerViewController
      }
    }
    // not embed in storyboard? add it manually
//    let drawer: DPDrawerViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPDrawerViewController") as? DPDrawerViewController
//    self.addChildViewController(drawer!)
//    self.view.addSubview(drawer!.view)

    let homeViewController: DPHomeViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPHomeViewController") as? DPHomeViewController
    let slideMenuModelProjects: DPSlideMenuModel = DPSlideMenuModel.init(
      color: UIColor.init(colorLiteralRed: 237.0 / 255.0,
        green: 140.0 / 255.0,
        blue: 52.0 / 255.0,
        alpha: 1.0),
      controllerClassName: "DPHomeViewController",
      title: "Projects",
      cellHeight: 108.0,
      actionBlock: nil)
    let slideMenuModelSupport: DPSlideMenuModel = DPSlideMenuModel.init(
      color: UIColor.init(colorLiteralRed: 140.0 / 255.0,
        green: 155.0 / 255.0,
        blue: 237.0 / 255.0,
        alpha: 1.0),
      controllerClassName: "DPSupportViewController",
      title: "Support",
      cellHeight: 88.0,
      actionBlock: nil)
    let slideMenuModelRate: DPSlideMenuModel = DPSlideMenuModel.init(
      color: UIColor.init(colorLiteralRed: 237.0 / 255.0,
        green: 140 / 255.0,
        blue: 200.0 / 255.0,
        alpha: 1.0),
      controllerClassName: nil,
      title: "Rate",
      cellHeight: 88.0,
      actionBlock: {
        let urlString: String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=910117892" // replace 910117892 with your appid
        UIApplication.shared.openURL(URL(string: urlString)!)
    })
    let slideMenuModelDonate: DPSlideMenuModel = DPSlideMenuModel.init(
      color: UIColor.init(colorLiteralRed: 237.0 / 255.0,
        green: 100.0 / 255.0,
        blue: 100.0 / 255.0,
        alpha: 1.0),
      controllerClassName: nil,
      title: "Donate",
      cellHeight: 88.0,
      actionBlock: {
        let targetURL: String = "https://qr.alipay.com/apeez0tpttrt2yove2"
        UIApplication.shared.openURL(URL(string: targetURL)!) // Donate with alipay
    })
    let slideMenuModels: [DPSlideMenuModel] = [slideMenuModelProjects, slideMenuModelSupport,
                                               slideMenuModelRate, slideMenuModelDonate]
    let leftMenuViewController: DPLeftMenuViewController = DPLeftMenuViewController.init(slideMenuModels: slideMenuModels, storyboard: self.storyboard)
    drawer?.reset(leftViewController: leftMenuViewController,
                  centerViewController: homeViewController)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

