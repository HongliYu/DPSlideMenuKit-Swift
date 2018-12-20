//
//  ViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? DPDrawerViewController,
      segue.identifier == "Main_Drawer" {
      DPSlideMenuManager.shared.setDrawer(drawer: destination)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let leftMenuVCTypes = [DPTeamViewController.self,
                           DPChannelListViewController.self,
                           DPMessageListViewController.self]
    let leftMenuViewControllers = UIViewController.baseEmbedControllers(leftMenuVCTypes,
                                                                        storyboard: "Pages")

    let rightMenuVCTypes = [DPSettingsViewController.self]
    let rightMenuViewControllers = UIViewController.baseEmbedControllers(rightMenuVCTypes,
                                                                         storyboard: "Pages")

    guard let homeViewController = instantiateVC(DPHomeViewController.self) else { return }
    DPSlideMenuManager.shared.setup(homeViewController,
                                    leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers)
  }
  
}
