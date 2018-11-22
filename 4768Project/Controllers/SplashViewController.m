//
//  SplashViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}


- (IBAction)signupAction:(id)sender {
    
    NSLog(@"Sign Up tapped");
}

- (IBAction)loginAction:(id)sender {
    NSLog(@"Login tapped");
}


@end
