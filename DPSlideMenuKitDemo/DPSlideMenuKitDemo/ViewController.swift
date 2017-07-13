//
//  ViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // embed in storyboard
    if segue.identifier == "Main_Drawer",
    segue.destination is DPDrawerViewController {
      DPSlideMenuManager.shared.setDrawer(drawer: segue.destination as? DPDrawerViewController)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1. not embed in storyboard? add it manually
//   let drawer: DPDrawerViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPDrawerViewController") as? DPDrawerViewController
//    self.addChildViewController(drawer!)
//    self.view.addSubview(drawer!.view)
//    DPSlideMenuManager.shared.setDrawer(drawer: drawer)
    
    let leftMenuViewControllerNameArray: [String] = ["DPTeamViewController",
                                                     "DPChannelListViewController",
                                                     "DPMessageListViewController"]
    let leftMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: leftMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]
    
    // 2. not from story board, add it manually
//    let leftMenuViewControllerNameArrayFromCode: [String] = ["DPTestViewController"]
//    let leftMenuViewControllersFromCode: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: leftMenuViewControllerNameArrayFromCode, storyboardName: nil, bundle: nil) as! [DPBaseEmbedViewController]
//    leftMenuViewControllers.append(contentsOf: leftMenuViewControllersFromCode)
    
    let rightMenuViewControllerNameArray: [String] = ["DPSettingsViewController"]
    let rightMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: rightMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]
    
    let homeViewController: DPHomeViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPHomeViewController") as? DPHomeViewController
    DPSlideMenuManager.shared.setup(leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers,
                                    centerContentViewController: homeViewController)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

