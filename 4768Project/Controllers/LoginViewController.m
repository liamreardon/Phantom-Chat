//
//  LoginViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginAction:(id)sender {
    
    [self signInWithEmail];
}

-(void)signInWithEmail
{
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        
        if (error == nil)
        {
            NSLog(@"Successful login!");
        }
        else
        {
            NSLog(@"error %@", error.localizedDescription);
        }
        
    }];
}


@end
