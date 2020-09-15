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

    // 4. If the viewcontroller is not generated from storyboard, set the storyboard param to nil,
    //    let leftMenuVCTypes = [DPTestViewController.self]
    //    let leftMenuViewControllers = UIViewController.baseEmbedControllers(leftMenuVCTypes,
    //                                                                        storyboard: nil)

    // 5. Center viewcontroller must inherited from DPCenterContentViewController, and can not be nil
    // guard let homeViewController = instantiateVC(DPHomeViewController.self) else { return }
    let leftMenuVCTypes = [DPTeamViewController.self,
                           DPChannelListViewController.self,
                           DPMessageListViewController.self]
    let rightMenuVCTypes = [DPSettingsViewController.self]

    guard let leftMenuViewControllers =
      UIViewController.viewControllers(leftMenuVCTypes,
                                       storyboard: "Pages") as? [DPBaseEmbedViewController],
    let rightMenuViewControllers =
      UIViewController.viewControllers(rightMenuVCTypes,
                                       storyboard: "Pages") as? [DPBaseEmbedViewController],
    let homeViewController =
      UIViewController.viewController(DPHomeViewController.self,
                                      storyboard: "Pages") as? DPHomeViewController else {
      return
    }

    // 6. Combine center, left, right, together. Meanwhile, left or right can be nil
    DPSlideMenuManager.shared.setup(homeViewController,
                                    leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers)
  }

  // 7. Pass status bar hide/show operation delegate to drawer
  open override var childForStatusBarHidden: UIViewController? {
    return DPSlideMenuManager.shared.drawer
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

}
