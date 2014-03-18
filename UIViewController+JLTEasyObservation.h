//
//  UIViewController+JLTEasyObservation.h
//  JLTEasyObservation
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. No rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JLTEasyObservation)

- (void)beginEasyObserving;
- (void)endEasyObserving;
@property (nonatomic, readonly, getter = isEasyObserving) BOOL easyObserving;

@property (copy, nonatomic) NSArray *easyObservationKeyPaths;
@property (copy, nonatomic) NSArray *easyNotificationNames;

@property (nonatomic, readonly, getter = isInitialEasyObservation) BOOL initialEasyObservation;

@end

@protocol JLTEasyNotification <NSObject>

- (void)observeEasyNotification:(NSNotification *)notification;

@end
