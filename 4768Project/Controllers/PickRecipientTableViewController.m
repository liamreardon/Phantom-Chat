//
//  PickRecipientTableViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "PickRecipientTableViewController.h"
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
        // Get user value
        
        NSLog(@"users: %@", snapshot.value);
        
        self.recipientsArray = [[NSMutableArray alloc] init];
        self.recipientsArray = [[snapshot.value allValues] mutableCopy];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
