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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jlt_keyboardMarkerBottomConstraint;
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
    if ([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification] ||
        [notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect frameEnd = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

        frameEnd = [self.view convertRect:frameEnd fromView:nil];
        CGFloat offset = self.view.bounds.size.height - frameEnd.origin.y;

        [self.view layoutIfNeeded];
        [UIView animateWithDuration:duration delay:0.0 options:curve << 16 animations:^{
            self.jlt_keyboardMarkerBottomConstraint.constant = offset;
            [self.view layoutIfNeeded];
        } completion:NULL];
    }
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.easyObservationKeyPaths = @[@"username", @"password", @"jlt_canLogin", @"jlt_canReset"];
    self.easyNotificationNames = @[UIKeyboardWillChangeFrameNotification, UIKeyboardWillHideNotification];
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
