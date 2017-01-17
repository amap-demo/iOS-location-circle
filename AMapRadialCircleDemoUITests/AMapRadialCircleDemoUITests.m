//
//  AMapRadialCircleDemoUITests.m
//  AMapRadialCircleDemoUITests
//
//  Created by eidan on 17/1/17.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AMapRadialCircleDemoUITests : XCTestCase

@end

@implementation AMapRadialCircleDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *element = [[app.scrollViews childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    
    [element pinchWithScale:3 velocity:5];
    
    sleep(1);
    
    [element swipeRight];
    
    sleep(1);
    
    [element swipeLeft];
    
    
    XCUIElement *locktoscreenButton = app.buttons[@"LockToScreen"];
    
    [locktoscreenButton tap];
    
    sleep(1);
    
    [element swipeRight];
    
    sleep(1);
    
    [element swipeLeft];
    
    sleep(2);
    
}

@end
