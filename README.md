# DPSlideMenuKit-Swift
Slide menu kit with left and right pages. Just like Slack!

[![Cocoapods](https://img.shields.io/cocoapods/v/DPSlideMenuKit.svg)](http://cocoapods.org/?q=DPSlideMenuKit)
[![Pod License](http://img.shields.io/cocoapods/l/DPSlideMenuKit.svg)](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/LICENSE)
[![Swift-5.2.4](https://img.shields.io/badge/Swift-5.2.4-blue.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/Demo.gif?raw=true" alt="alt text"  height="400">


## View Controllers Hierarchy
<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/ViewControllers.png?raw=true" alt="alt text"  height="400">


## Usage

```  swift
  // 1. IF embed in storyboard
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? DPDrawerViewController,
      segue.identifier == "Main_Drawer" {
      DPSlideMenuManager.shared.setDrawer(drawer: destination)
    }
  }
```
<img src="https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/EmbedDrawer.png?raw=true" alt="alt text"  height="400">

```  swift
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 2. IF NOT embed in storyboard, set drawer manually
    //    let drawer = DPDrawerViewController()
    //    addChild(drawer)
    //    view.addSubview(drawer.view)
    //    DPSlideMenuManager.shared.setDrawer(drawer: drawer)
    
    // 3. Add view controllers in the left & right side, which shall be inherited from DPBaseEmbedViewController

    // Tips: If the viewcontroller is not generated from storyboard, set the storyboard param to nil,
    //    let leftMenuVCTypes = [DPTestViewController.self]
    //    let leftMenuViewControllers = UIViewController.baseEmbedControllers(leftMenuVCTypes, storyboard: nil)

    // 4. Center viewcontroller shall be inherited from DPCenterContentViewController, which also can not be nil
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

    // 5. Combine center, left, right, together. Meanwhile, left or right can be nil
    DPSlideMenuManager.shared.setup(homeViewController,
                                    leftContentEmbedViewControllers: leftMenuViewControllers,
                                    rightContentEmbedViewControllers: rightMenuViewControllers)
  }

  // 6. Pass status bar hide/show delegate to drawer, let drawer manager the logic
  open override var childForStatusBarHidden: UIViewController? {
    return DPSlideMenuManager.shared.drawer
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

```
