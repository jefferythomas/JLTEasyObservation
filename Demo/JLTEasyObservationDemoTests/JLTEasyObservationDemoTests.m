//
//  JLTEasyObservationDemoTests.m
//  JLTEasyObservationDemoTests
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. All rights reserved.
//

#import "JLTEasyObservationDemoTests.h"
#import "UIViewController+JLTEasyObservation.h"

@interface JLTTestViewController : UIViewController <JLTEasyNotification>
@property (nonatomic) NSString *test;
@property (nonatomic) BOOL changeWasObserved;
@property (nonatomic) BOOL wasInitiallyObserved;
@property (nonatomic) BOOL wasNotified;
@end

@implementation JLTEasyObservationDemoTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEasyObservationInitialEasyObservation
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];

    STAssertTrue(viewController.wasInitiallyObserved, nil);
}

- (void)testEasyObservationChangeWasObserved
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    viewController.test = @"test";
    [viewController endEasyObserving];

    STAssertTrue(viewController.changeWasObserved, nil);
}

- (void)testEasyObservationChangeWasNotObserved
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyObservationKeyPaths = @[@"test"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];
    viewController.test = @"test";

    STAssertFalse(viewController.changeWasObserved, nil);
}

- (void)testEasyObservationWasNotified
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyNotificationNames = @[@"JLTTestNotification"];
    [viewController beginEasyObserving];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JLTTestNotification" object:self];
    [viewController endEasyObserving];

    STAssertTrue(viewController.wasNotified, nil);
}

- (void)testEasyObservationWasNotNotified
{
    JLTTestViewController *viewController = [[JLTTestViewController alloc] init];
    viewController.easyNotificationNames = @[@"JLTTestNotification"];
    [viewController beginEasyObserving];
    [viewController endEasyObserving];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JLTTestNotification" object:self];

    STAssertFalse(viewController.wasNotified, nil);
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
