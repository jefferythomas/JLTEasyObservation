//
//  UIViewController+JLTEasyObservation.m
//  JLTEasyObservationDemo
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. All rights reserved.
//

#import "UIViewController+JLTEasyObservation.h"
#import <objc/runtime.h>

@interface UIViewController ()
@property (assign, nonatomic, getter = isInitialEasyObservation) BOOL initialEasyObservation;
@property (strong, nonatomic, readonly) NSMutableDictionary *JLT_easyObservationDict;
@end

@implementation UIViewController (JLTEasyObservation)

- (void)beginEasyObserving
{
    if (self.easyObserving) return;

    self.JLT_easyObservationDict[@"easyObserving"] = @YES;

    SEL selector = @selector(observeEasyNotification:);
    if ([self respondsToSelector:selector])
        for (NSString *name in self.easyNotificationNames)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];

    self.initialEasyObservation = YES;
    for (NSString *keyPath in self.easyObservationKeyPaths)
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionInitial context:NULL];
    self.initialEasyObservation = NO;
}

- (void)endEasyObserving
{
    if (!self.easyObserving) return;

    SEL selector = @selector(observeEasyNotification:);
    if ([self respondsToSelector:selector])
        for (NSString *name in self.easyNotificationNames)
            [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];

    for (NSString *keyPath in self.easyObservationKeyPaths)
        [self removeObserver:self forKeyPath:keyPath context:NULL];

    self.JLT_easyObservationDict[@"easyObserving"] = @NO;
}

#pragma mark Properties

- (BOOL)isEasyObserving
{
    return [self.JLT_easyObservationDict[@"easyObserving"] boolValue];
}

- (void)setEasyObserving:(BOOL)easyObserving
{
    if (self.easyObserving) [self beginEasyObserving];
    else                    [self endEasyObserving];
}

- (NSArray *)easyObservationKeyPaths
{
    return self.JLT_easyObservationDict[@"easyObservationKeyPaths"];
}

- (void)setEasyObservationKeyPaths:(NSArray *)easyObservationKeyPaths
{
    BOOL observing = self.easyObserving;

    if (observing) self.easyObserving = NO;
    self.JLT_easyObservationDict[@"easyObservationKeyPaths"] = [easyObservationKeyPaths copy];
    if (observing) self.easyObserving = YES;
}

- (NSArray *)easyNotificationNames
{
    return self.JLT_easyObservationDict[@"easyNotificationNames"];
}

- (void)setEasyNotificationNames:(NSArray *)easyNotificationNames
{
    BOOL observing = self.easyObserving;

    if (observing) self.easyObserving = NO;
    self.JLT_easyObservationDict[@"easyNotificationNames"] = [easyNotificationNames copy];
    if (observing) self.easyObserving = YES;
}

- (BOOL)isInitialEasyObservation
{
    return [self.JLT_easyObservationDict[@"initialEasyObservation"] boolValue];
}

- (void)setInitialEasyObservation:(BOOL)initialEasyObservation
{
    self.JLT_easyObservationDict[@"initialEasyObservation"] = @(initialEasyObservation);
}

- (NSMutableDictionary *)JLT_easyObservationDict
{
    static char key;
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);

    if (!dict) {
        dict = [NSMutableDictionary dictionaryWithCapacity:4];
        objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

@end
