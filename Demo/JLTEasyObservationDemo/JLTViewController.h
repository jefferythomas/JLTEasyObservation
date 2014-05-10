//
//  JLTViewController.h
//  JLTEasyObservationDemo
//
//  Created by Jeffery Thomas on 7/26/13.
//  Copyright (c) 2013 JLT Source. No rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLTViewController : UIViewController

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)loginUser:(id)sender;
- (IBAction)resetForm:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
