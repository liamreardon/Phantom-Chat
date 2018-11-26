//
//  HomeTableTableViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "HomeTableTableViewController.h"
#import "MessageViewController.h"
#import "SplashViewController.h"
@import Firebase;

@interface HomeTableTableViewController ()

@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) NSMutableArray *keysArray;



@end

@implementation HomeTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMessages];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = refreshControl;
    } else {
        [self.tableView addSubview:refreshControl];
    }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}
- (IBAction)logoutAction:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    
    if (error == nil)
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SplashViewController * splashVC = [storyboard instantiateViewControllerWithIdentifier:@"splashViewController"];
        
        [self.navigationController setViewControllers:@[splashVC] animated:YES];
    }
}

-(void)getMessages {
    
    NSString * userID = [FIRAuth auth].currentUser.uid;
    
    FIRDatabaseReference * databaseRef = [[FIRDatabase database] reference];
    
    FIRDatabaseQuery * messagesQuery = [[databaseRef child:@"messages"] child:userID];
    
    FIRDatabaseReference * ref = messagesQuery.ref;
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

        NSDictionary * queryResult = snapshot.value;
        
        if ([queryResult isKindOfClass:[NSNull class]] == YES)
        {
            [self.tableView reloadData];
            return;
            
        }

        self.messagesArray = [NSMutableArray array];

        self.messagesArray = [[queryResult allValues] mutableCopy];

        self.keysArray = [[queryResult allKeys] mutableCopy];

        [self.tableView reloadData];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.messagesArray == nil || self.messagesArray.count == 0)
    {
        return 1;
    }
    
    return self.messagesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (self.messagesArray == nil || self.messagesArray.count == 0)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"pushToViewMessage" sender:self];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"];
    
    // downloading messages
    
    if (self.messagesArray == nil)
    {
        cell.textLabel.text = @"Loading...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    // Recipients
    
    if (self.messagesArray.count == 0)
    {
        cell.textLabel.text = @"Sorry, you have no messages :(";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    
    NSDictionary *messageInfo = [self.messagesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [messageInfo objectForKey:@"messageText"];
    cell.detailTextLabel.text = [messageInfo objectForKey:@"senderUsername"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToViewMessage"] == YES)
    {
        MessageViewController * viewMessageController = (MessageViewController * )segue.destinationViewController;
        
        viewMessageController.messageInfo = [self.messagesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        viewMessageController.messageKey = [self.keysArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


@end
