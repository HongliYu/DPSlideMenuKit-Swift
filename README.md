# DPSlideMenuKit-Swift
Slide menu kit with left and right pages. Just like Slack!

[![Cocoapods](https://img.shields.io/cocoapods/v/DPSlideMenuKit.svg)](http://cocoapods.org/?q=DPSlideMenuKit)
[![Pod License](http://img.shields.io/cocoapods/l/DPSlideMenuKit.svg)](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/LICENSE)
[![Swift-3.1](https://img.shields.io/badge/Swift-3.1-blue.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/Demo.gif?raw=true" alt="alt text"  height="400">

# Usage

```  swift
    // 1. Embed the drawer controller in storyboard, that means add the drawer controller as the child controller of current view controller
    // 2. add this func for embed segur id
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "Main_Drawer",
      segue.destination is DPDrawerViewController {
        DPSlideMenuManager.shared.setDrawer(drawer: segue.destination as? DPDrawerViewController)
      }
    }

```
<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/EmbedDrawer.png?raw=true" alt="alt text"  height="400">

```  swift
    //  3. If not embed in storyboard? add it manually in code
    //  let drawer: DPDrawerViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPDrawerViewController") as? DPDrawerViewController
    //  self.addChildViewController(drawer!)
    //  self.view.addSubview(drawer!.view)
    //  DPSlideMenuManager.shared.setDrawer(drawer: drawer)
```

```  swift
    // 4. Add view controllers in the left side, which are configured in the storyboard
    let leftMenuViewControllerNameArray: [String] = ["DPTeamViewController",
                                                     "DPChannelListViewController",
                                                     "DPMessageListViewController"]
    let leftMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: leftMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]

    //  5. If not from story board, mark the storyboardName is nil, and the related view controller will be generated without story board
    //  let leftMenuViewControllerNameArrayFromCode: [String] = ["DPTestViewController"]
    //  let leftMenuViewControllersFromCode: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: leftMenuViewControllerNameArrayFromCode, storyboardName: nil, bundle: nil) as! [DPBaseEmbedViewController]
    //  leftMenuViewControllers.append(contentsOf: leftMenuViewControllersFromCode)

    // 6. So does the right side
    let rightMenuViewControllerNameArray: [String] = ["DPSettingsViewController"]
    let rightMenuViewControllers: [DPBaseEmbedViewController] = UIViewController.generateViewControllersFrom(viewControllerNameArray: rightMenuViewControllerNameArray, storyboardName: "Main", bundle: nil) as! [DPBaseEmbedViewController]

    // 7. Add the first center view controller
    let homeViewController: DPHomeViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DPHomeViewController") as? DPHomeViewController

    // 8. Setup left, right, center, become one
    DPSlideMenuManager.shared.setup(leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers,
                                    centerContentViewController: homeViewController)
```
