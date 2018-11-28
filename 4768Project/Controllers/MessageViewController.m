//
//  MessageViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-22.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "MessageViewController.h"
#import "HomeTableTableViewController.h"
@import Firebase;

@interface MessageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTimer;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currSeconds = 5;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    [self setupInterface];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [self.timer invalidate];
    self.timer = nil;
    
}

    


-(void)timerFired {
    
    if(currSeconds > 0)
    {
        if(currSeconds>0)
        {
            currSeconds-=1;
            [self.messageTimer setText:[NSString stringWithFormat:@"%d", currSeconds]];
        }
        
    }
    else if (currSeconds == 0)
    {
        [self destructMessage];
        [self popToHomeViewController];
        
    }
}

-(void)setupInterface {
    self.messageTextLabel.text = [self.messageInfo objectForKey:@"messageText"];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.messageInfo objectForKey:@"senderUsername"]];
    
    [self getImageFromFirebase];
    
}

-(void)getImageFromFirebase {
    
    FIRStorageReference * storageRef = [[FIRStorage storage] reference];
    
    NSString * imagesPath = [NSString stringWithFormat:@"/images/%@", self.messageKey];
    
    FIRStorageReference * imagesRef = [storageRef child:imagesPath];
    
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [imagesRef dataWithMaxSize:5 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"data: %@", error.localizedDescription);
        } else {
            
            self.messageImageView.image = [UIImage imageWithData:data];
        }
    }];
    
}

-(void)popToHomeViewController {
    
    NSMutableArray * allViewController = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController * aViewController in allViewController)
    {
        if ([aViewController isKindOfClass:[HomeTableTableViewController class]])
        {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

-(void)destructMessage {
    
    NSString * userID = [FIRAuth auth].currentUser.uid;
    
    FIRDatabaseReference * databaseRef = [[FIRDatabase database] reference];
    
    FIRDatabaseQuery * messagesQuery = [[[databaseRef child:@"messages"] child:userID] child:self.messageKey];
    
    FIRDatabaseReference * ref = messagesQuery.ref;
    
    [ref removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error != nil)
        {
            NSLog(@"error %@", error);
        }
        else
        {
            NSLog(@"ref %@", ref);
            NSLog(@"message successfully destructed");
        }
    }];
    

    
}


@end
