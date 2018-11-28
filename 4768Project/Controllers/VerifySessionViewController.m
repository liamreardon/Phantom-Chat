//
//  VerifySessionViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "VerifySessionViewController.h"
#import "HomeTableTableViewController.h"
#import <Lottie/Lottie.h>
@import Firebase;



@interface VerifySessionViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation VerifySessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if (user != nil)
            {
                HomeTableTableViewController * homeTableView = [storyBoard instantiateViewControllerWithIdentifier:@"homeView"];
                
                [self.navigationController setViewControllers:@[homeTableView] animated:YES];
                
            }
            else
            {
                [self performSegueWithIdentifier:@"pushToSplashViewSegue" sender:self];
            }
            
        });

            
    }];
}


@end
