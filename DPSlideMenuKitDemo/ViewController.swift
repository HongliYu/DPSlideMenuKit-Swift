//
//  ViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // 1. If embed in storyboard
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? DPDrawerViewController,
      segue.identifier == "Main_Drawer" {
      DPSlideMenuManager.shared.setDrawer(drawer: destination)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 2. If not embed in storyboard, set drawer manually
    //    let drawer = DPDrawerViewController()
    //    addChild(drawer)
    //    view.addSubview(drawer.view)
    //    DPSlideMenuManager.shared.setDrawer(drawer: drawer)
    
    // 3. Add view controllers in the left & right side,
    // and they must be inherited from DPBaseEmbedViewController
    let leftMenuVCTypes = [DPTeamViewController.self,
                           DPChannelListViewController.self,
                           DPMessageListViewController.self]
    let leftMenuViewControllers = UIViewController.baseEmbedControllers(leftMenuVCTypes,
                                                                        storyboard: "Pages")
    
    let rightMenuVCTypes = [DPSettingsViewController.self]
    let rightMenuViewControllers = UIViewController.baseEmbedControllers(rightMenuVCTypes,
                                                                         storyboard: "Pages")
    
    // 4. If the viewcontroller is not generated from storyboard, set the storyboard param to nil,
    //    let leftMenuVCTypes = [DPTestViewController.self]
    //    let leftMenuViewControllers = UIViewController.baseEmbedControllers(leftMenuVCTypes,
    //                                                                        storyboard: nil)

    // 5. Center viewcontroller must inherited from DPCenterContentViewController, and can not be nil
    guard let homeViewController = instantiateVC(DPHomeViewController.self) else { return }
    
    // 6. Combine center, left, right, together. Meanwhile, left or right can be nil
    DPSlideMenuManager.shared.setup(homeViewController,
                                    leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers)
  }
  
}
