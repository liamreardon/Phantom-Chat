//
//  LoginViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "LoginViewController.h"
@import Firebase;
@import QuartzCore;

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
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
            [self performSegueWithIdentifier:@"successfulLoginSegue" sender:self];
        }
        else
        {
            NSLog(@"error %@", error.localizedDescription);
            [self showAlertController];
        }
        
    }];
}

-(void)showAlertController {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Invalid Credentials" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
