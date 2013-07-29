//
//  UIViewController+JLTEasyObservation.h
//  JLTEasyObservationDemo
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JLTEasyObservation)

- (void)beginEasyObserving;
- (void)endEasyObserving;
@property (assign, nonatomic, getter = isEasyObserving) BOOL easyObserving;

@property (copy, nonatomic) NSArray *easyObservationKeyPaths;
@property (copy, nonatomic) NSArray *easyNotificationNames;

@property (assign, nonatomic, readonly, getter = isInitialEasyObservation) BOOL initialEasyObservation;

@end

@protocol JLTEasyNotification <NSObject>

- (void)observeEasyNotification:(NSNotification *)notification;

@end
