# DPSlideMenuKit-Swift
simple slide menu kit with different colors

[![Cocoapods](https://img.shields.io/cocoapods/v/DPSlideMenuKit.svg)](http://cocoapods.org/?q=DPSlideMenuKit)
[![Pod License](http://img.shields.io/cocoapods/l/DPSlideMenuKit.svg)](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/LICENSE)

![screenshot](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/DPSlideMenuKit.gif?raw=true)

# Usage

```  swift
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
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
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
        UIApplication.sharedApplication().openURL(NSURL(string: targetURL)!) // Donate with alipay
    })
    let slideMenuModels: [DPSlideMenuModel] = [slideMenuModelProjects, slideMenuModelSupport, slideMenuModelRate, slideMenuModelDonate]
    let leftMenuViewController: DPLeftMenuViewController = DPLeftMenuViewController.init(slideMenuModels: slideMenuModels)
    var drawer: DPDrawerViewController = DPDrawerViewController.init(leftViewController: leftMenuViewController, centerViewController: homeViewController)
    self.presentViewController(drawer, animated: false, completion: nil)

```