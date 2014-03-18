//
//  UIViewController+JLTEasyObservation.m
//  JLTEasyObservation
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. No rights reserved.
//

#import "UIViewController+JLTEasyObservation.h"
#import <objc/runtime.h>

@interface UIViewController ()
@property (nonatomic, getter = isInitialEasyObservation) BOOL initialEasyObservation;
@property (nonatomic, readonly) NSMutableDictionary *JLT_easyObservationDict;
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

- (NSArray *)easyObservationKeyPaths
{
    return self.JLT_easyObservationDict[@"easyObservationKeyPaths"];
}

- (void)setEasyObservationKeyPaths:(NSArray *)easyObservationKeyPaths
{
    BOOL observing = self.easyObserving;

    if (observing) [self endEasyObserving];
    self.JLT_easyObservationDict[@"easyObservationKeyPaths"] = [easyObservationKeyPaths copy];
    if (observing) [self beginEasyObserving];
}

- (NSArray *)easyNotificationNames
{
    return self.JLT_easyObservationDict[@"easyNotificationNames"];
}

- (void)setEasyNotificationNames:(NSArray *)easyNotificationNames
{
    BOOL observing = self.easyObserving;

    if (observing) [self endEasyObserving];
    self.JLT_easyObservationDict[@"easyNotificationNames"] = [easyNotificationNames copy];
    if (observing) [self beginEasyObserving];
}

- (BOOL)isInitialEasyObservation
{
    return [self.JLT_easyObservationDict[@"initialEasyObservation"] boolValue];
}

- (void)setInitialEasyObservation:(BOOL)initialEasyObservation
{
    self.JLT_easyObservationDict[@"initialEasyObservation"] = initialEasyObservation ? @YES : @NO;
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
