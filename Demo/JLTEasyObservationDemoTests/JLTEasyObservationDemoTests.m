//
//  JLTEasyObservationDemoTests.m
//  JLTEasyObservationDemoTests
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIViewController+JLTEasyObservation.h"

@interface JLTEasyObservationDemoTests : XCTestCase

@end

@interface JLTTestViewController : UIViewController <JLTEasyNotifying>
@property (nonatomic) NSString *test;
@property (nonatomic) BOOL changeWasObserved;
@property (nonatomic) BOOL wasInitiallyObserved;
@property (nonatomic) BOOL wasNotified;
@end

@implementation JLTEasyObservationDemoTests

- (void)testEasyObservationInitialEasyObservation
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];

    XCTAssertTrue(viewController.wasInitiallyObserved);
}

- (void)testEasyObservationChangeWasObserved
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    viewController.test = @"test";
    [viewController endEasyObserving];

    XCTAssertTrue(viewController.changeWasObserved);
}

- (void)testEasyObservationChangeWasNotObserved
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];
    viewController.test = @"test";

    XCTAssertFalse(viewController.changeWasObserved);
}

- (void)testEasyObservationWasNotified
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyNotificationNames = @[@"JLTTestNotification"];
    [viewController beginEasyObserving];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JLTTestNotification" object:self];
    [viewController endEasyObserving];

    XCTAssertTrue(viewController.wasNotified);
}

- (void)testEasyObservationWasNotNotified
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyNotificationNames = @[@"JLTTestNotification"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JLTTestNotification" object:self];

    XCTAssertFalse(viewController.wasNotified);
}

@end

@implementation JLTTestViewController
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (self.initialEasyObservation)
        self.wasInitiallyObserved = YES;

    if ([keyPath isEqualToString:@"test"]) {
        if (!self.initialEasyObservation)
            self.changeWasObserved = YES;
    }
}

- (void)observeEasyNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"JLTTestNotification"]) {
        self.wasNotified = YES;
    }
}
@end
