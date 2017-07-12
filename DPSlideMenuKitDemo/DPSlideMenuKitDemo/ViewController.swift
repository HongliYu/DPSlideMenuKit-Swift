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
    // let drawer: DPDrawerViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPDrawerViewController") as? DPDrawerViewController
    //  self.addChildViewController(drawer!)
    //  self.view.addSubview(drawer!.view)
    
    let leftMenuViewControllerNameArray: [String] = ["DPTeamViewController",
                                                     "DPChannelListViewController",
                                                     "DPMessageListViewController"]
    let leftMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: leftMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]
    
    let rightMenuViewControllerNameArray: [String] = ["DPSettingsViewController"]
    let rightMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: rightMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]
    
    DPSlideMenuManager.shared.config(leftContentEmbedViewControllers: leftMenuViewControllers,
                                     rightContentEmbedViewControllers: rightMenuViewControllers)
    
    let homeViewController: DPHomeViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPHomeViewController") as? DPHomeViewController
    let leftMenuViewController: DPLeftMenuViewController = DPLeftMenuViewController()
    let rightMenuViewController: DPRightMenuViewController = DPRightMenuViewController()
    
    DPSlideMenuManager.shared.setup(leftMenuViewController: leftMenuViewController,
                                    rightMenuViewController: rightMenuViewController,
                                    centerContentViewController: homeViewController)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

