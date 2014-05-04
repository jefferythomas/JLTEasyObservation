//
//  JLTViewController.m
//  JLTEasyObservationDemo
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. All rights reserved.
//

#import "JLTViewController.h"
#import "UIViewController+JLTEasyObservation.h"

@interface JLTViewController () <JLTEasyNotification>
@property (copy, nonatomic) NSString *test;
@end

@implementation JLTViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath --> %@", keyPath);
}

- (void)observeEasyNotification:(NSNotification *)notification
{
    NSLog(@"notification.name --> %@", notification.name);
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.easyObservationKeyPaths = @[@"test"];
    self.easyNotificationNames = @[UIKeyboardDidShowNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginEasyObserving];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEasyObserving];
}

@end
