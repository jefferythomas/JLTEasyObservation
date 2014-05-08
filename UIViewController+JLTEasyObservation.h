//
//  UIViewController+JLTEasyObservation.h
//  JLTEasyObservation
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. No rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JLTEasyObservation)

/// @brief Enable easy observing and send the initial easy observation.
///
/// This message is typically passed in -viewWillAppear:. Key paths in easyObservationKeyPaths are added by
/// sending [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionInitial context:NULL].
/// Notifications with the names in easyNotificationNames are added by sending
/// [center addObserver:self selector:@selector(observeEasyNotification:) name:name object:nil].
- (void)beginEasyObserving;

/// @brief Disable easy observing.
///
/// This message is typically passed in -viewWillDisappear:. All observers added by easy observation are
/// removed.
- (void)endEasyObserving;

/// @brief YES if easy observing is currently enabled, otherwise NO.
@property (nonatomic, readonly, getter = isEasyObserving) BOOL easyObserving;

/// @brief An array of key paths are observed while easy observing is enabled.
@property (copy, nonatomic) NSArray *easyObservationKeyPaths;

/// @brief An array of notification names are observed while easy observing is enabled.
@property (copy, nonatomic) NSArray *easyNotificationNames;

/// @brief In the implmentation of -observeValueForKeyPath:ofObject:change:context:, YES if the messages was
/// passed because of NSKeyValueObservingOptionInitial, otherwise NO.
@property (nonatomic, readonly, getter = isInitialEasyObservation) BOOL initialEasyObservation;

@end

/// @brief The easy notifying protocol is used to observe NSNotification posts in a very similar way as
/// easy observing.
///
/// When a view controller conforms to easy notifying (duck typing is all that's needed), all notifications
/// with names in easyNotificationNames are passed to -observeEasyNotification:. This observing start with
/// -beginEasyObserving and stops with endEasyObserving just like easy observation.
@protocol JLTEasyNotifying <NSObject>

/// @brief The method invoked when a notification is posted that is named in easyNotificationNames.
- (void)observeEasyNotification:(NSNotification *)notification;

@end
