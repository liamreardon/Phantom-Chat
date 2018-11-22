//
//  SignUpViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)submitButtonAction:(id)sender {
    
    if (self.emailTextField.text.length > 0 &&
        self.usernameTextField.text.length > 0 &&
        self.passwordTextField.text.length > 0)
    {
        [self signUpUserWithEmail:self.emailTextField.text
                         password:self.passwordTextField.text
                         username:self.usernameTextField.text];
    }
    else
    {
        UIAlertController * alertController = [UIAlertController
                                               alertControllerWithTitle:@"Oops"
                                               message:@"Please make sure all fields are filled out"
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * confirmationAction = [UIAlertAction actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleDefault
                                       handler:nil];
        
        [alertController addAction:confirmationAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
                                               
    }
    
}

-(void)signUpUserWithEmail:(NSString *)email
                  password:(NSString *)password
                  username:(NSString *)username {
    
    [[FIRAuth auth] createUserWithEmail:email
                    password:password
                    completion:^(FIRAuthDataResult * _Nullable authResult,
                    NSError * _Nullable error) {
                    
                        NSLog(@"user %@ error %@", authResult, error);
                        
                        if (error == nil)
                        {
                            
                            FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                            changeRequest.displayName = username;
                            
                            [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
                                if (error)
                                {
                                    NSLog(@"error %@", error.localizedDescription);
                                }
                                else
                                {
                                    // profile updated
                                }
                            }];
                            
                            self.ref = [[FIRDatabase database] reference];
                            
                            FIRDatabaseReference * usersRef = [[self.ref child:@"users"] child: authResult.user.uid];
                            
                            NSDictionary * userInfo = @{@"uid" : authResult.user.uid,
                                                        @"username" : username
                                                       };
                            
                            [usersRef setValue:userInfo];
                        
                        
                        }
                        else
                        {
                            
                        }
                                 
                        
                    }];
    
}


@end
