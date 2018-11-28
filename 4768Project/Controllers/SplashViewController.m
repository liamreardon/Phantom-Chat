//
//  SplashViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "SplashViewController.h"
#import <Lottie/Lottie.h>
@import QuartzCore;

@interface SplashViewController ()
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signupButton.clipsToBounds = YES;
    self.signupButton.layer.cornerRadius = self.signupButton.frame.size.height/2;
    self.signupButton.layer.borderWidth = 2;
    self.signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    LOTAnimationView *animView = [LOTAnimationView animationNamed:@"spirit_geek"];
    animView.center = CGPointMake(205, 310);
    animView.loopAnimation = true;
    [self.view addSubview:animView];
    [animView playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"Anim finished");
    }];
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
