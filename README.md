# DPSlideMenuKit-Swift
Slide menu kit with left and right pages. Just like Slack!

[![Cocoapods](https://img.shields.io/cocoapods/v/DPSlideMenuKit.svg)](http://cocoapods.org/?q=DPSlideMenuKit)
[![Pod License](http://img.shields.io/cocoapods/l/DPSlideMenuKit.svg)](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/LICENSE)
[![Swift-4.0](https://img.shields.io/badge/Swift-4.2-blue.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/Demo.gif?raw=true" alt="alt text"  height="400">

# Usage

```  swift
  // 1. If embed in storyboard
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? DPDrawerViewController,
      segue.identifier == "Main_Drawer" {
      DPSlideMenuManager.shared.setDrawer(drawer: destination)
    }
  }



```
<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/EmbedDrawer.png?raw=true" alt="alt text"  height="400">

```  swift
    // 2. If not embed in storyboard, set drawer manually
    //    let drawer = DPDrawerViewController()
    //    addChild(drawer)
    //    view.addSubview(drawer.view)
    //    DPSlideMenuManager.shared.setDrawer(drawer: drawer)
    
    // 3. Add view controllers in the left & right side, and they must be inherited from DPBaseEmbedViewController
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

    // 5. Center viewcontroller must be inherited from DPCenterContentViewController, and can not be nil
    guard let homeViewController = instantiateVC(DPHomeViewController.self) else { return }
    
    // 6. Combine center, left, right, together. Meanwhile, left or right can be nil
    DPSlideMenuManager.shared.setup(homeViewController,
                                    leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers)


```
