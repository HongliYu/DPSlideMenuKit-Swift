//
//  DPSlideMenuKitDemoUITests.swift
//  DPSlideMenuKitDemoUITests
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import XCTest

class DPSlideMenuKitDemoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
      XCUIDevice.shared().orientation = .portrait
      XCUIDevice.shared().orientation = .portrait
      XCUIDevice.shared().orientation = .faceUp
      
      let app = XCUIApplication()
      let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
      let button = element.children(matching: .button).element
      button.tap()
      
      let tablesQuery = app.tables
      let supportStaticText = tablesQuery.staticTexts["Support"]
      supportStaticText.tap()
      button.tap()
      tablesQuery.staticTexts["Projects"].tap()
      element.swipeRight()
      
      let donateStaticText = tablesQuery.staticTexts["Donate"]
      donateStaticText.swipeLeft()
      element.swipeRight()
      supportStaticText.tap()
    }
    
}
