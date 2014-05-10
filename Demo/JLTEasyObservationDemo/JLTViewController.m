//
//  JLTViewController.m
//  JLTEasyObservationDemo
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. No rights reserved.
//

#import "JLTViewController.h"
#import "UIViewController+JLTEasyObservation.h"

@interface JLTViewController () <JLTEasyNotifying, UITextFieldDelegate>
@property (nonatomic, readonly) BOOL jlt_canLogin;
@property (nonatomic, readonly) BOOL jlt_canReset;
@end

@implementation JLTViewController

- (IBAction)loginUser:(id)sender
{
    self.password = nil;
}

- (IBAction)resetForm:(id)sender
{
    self.username = nil;
    self.password = nil;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.usernameTextField) {
        self.username = text;
    } else if (textField == self.passwordTextField) {
        self.password = text;
    }

    return YES;
}

#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"username"]) {
        if (!self.usernameTextField.editing)
            self.usernameTextField.text = self.username;
    } else if ([keyPath isEqualToString:@"password"]) {
        if (!self.passwordTextField.editing)
            self.passwordTextField.text = self.password;
    } else if ([keyPath isEqualToString:@"jlt_canLogin"]) {
        self.loginButton.enabled = self.jlt_canLogin;
    } else if ([keyPath isEqualToString:@"jlt_canReset"]) {
        self.resetButton.enabled = self.jlt_canReset;
    }
}

#pragma mark JLTEasyObserving

- (void)observeEasyNotification:(NSNotification *)notification
{
    NSLog(@"%@", notification);
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.easyObservationKeyPaths = @[@"username", @"password", @"jlt_canLogin", @"jlt_canReset"];
    self.easyNotificationNames = @[UIKeyboardWillChangeFrameNotification];
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

#pragma mark Properties

- (BOOL)jlt_canLogin
{
    return [self.username length] > 0 && [self.password length] > 0;
}

+ (NSSet *)keyPathsForValuesAffectingJlt_canLogin
{
    return [NSSet setWithArray:@[@"username", @"password"]];
}

- (BOOL)jlt_canReset
{
    return [self.username length] > 0 || [self.password length] > 0;
}

+ (NSSet *)keyPathsForValuesAffectingJlt_canReset
{
    return [NSSet setWithArray:@[@"username", @"password"]];
}

@end
