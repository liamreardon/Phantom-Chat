//
//  PickRecipientTableViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "PickRecipientTableViewController.h"
#import "CreateMessageViewController.h"
@import Firebase;

@interface PickRecipientTableViewController ()

@property (strong, nonatomic) NSMutableArray * recipientsArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation PickRecipientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getRecipients];
    
}

-(void)getRecipients {
    
    self.ref = [[FIRDatabase database] reference];
    
    FIRDatabaseReference * usersRef = [self.ref child:@"users"];
    
    [usersRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
       
        
        self.recipientsArray = [[NSMutableArray alloc] init];
        self.recipientsArray = [[snapshot.value allValues] mutableCopy];
        
        NSLog(@"users: %@", self.recipientsArray);
        
        [self.tableView reloadData];
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.recipientsArray == nil || self.recipientsArray.count == 0)
    {
        return 1;
    }
    return self.recipientsArray.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (self.recipientsArray == nil || self.recipientsArray.count == 0)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"pushToMessageSegue" sender:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipientReuse" forIndexPath:indexPath];
    
    
    // downloading recipients
    
    if (self.recipientsArray == nil)
    {
        cell.textLabel.text = @"Loading...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    // Recipients
    
    if (self.recipientsArray.count == 0)
    {
        cell.textLabel.text = @"Add friends to send messages!";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    
    NSDictionary *userInfo = [self.recipientsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [userInfo objectForKey:@"username"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToMessageSegue"] == YES)
    {
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            
            CreateMessageViewController * messageViewController = (CreateMessageViewController * )segue.destinationViewController;
            
            NSLog(@"INDEX%ld", indexPath.row);
            
            messageViewController.recipientInfo = self.recipientsArray[indexPath.row];
        }       
        
    }
}


@end
