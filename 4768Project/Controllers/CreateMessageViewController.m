//
//  CreateMessageViewController.m
//  4768Project
//
//  Created by Liam  on 2018-11-21.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import "CreateMessageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HomeTableTableViewController.h"
@import Firebase;
@import QuartzCore;

@interface CreateMessageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation CreateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendButton.clipsToBounds = YES;
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2;
    
    NSLog(@"%@", self.recipientInfo);

    
    UITapGestureRecognizer * tapPicture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture)];
    
    self.messageImageView.userInteractionEnabled = YES;
    
    [self.messageImageView addGestureRecognizer:tapPicture];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

-(void)choosePicture {
    [self chooseMessagePictureForImageView:self.messageImageView];
}



#pragma imageview picker code

-(void)chooseMessagePictureForImageView:(UIImageView *)imageView {
    
    BOOL hasPhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (hasPhotoLibrary == NO && hasCamera == NO)
    {
        return;
    }
    
    if (hasPhotoLibrary == YES || hasCamera == YES)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Choose Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        if (hasCamera == YES)
        {
            UIAlertAction * useCameraAction = [UIAlertAction actionWithTitle:@"From Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentImagePickerUsingCamera:YES];
            }];
            
            [alertController addAction:useCameraAction];
        }
        
        UIAlertAction * usePhotosAction = [UIAlertAction actionWithTitle:@"From Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerUsingCamera:NO];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:usePhotosAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)presentImagePickerUsingCamera:(BOOL)useCamera {
    
    UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
    
    if (useCamera == YES)
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    pickerController.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary *)info {
    
    [self dismissImagePicker];
    
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        
        self.messageImageView.image = image;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissImagePicker];
}

-(void)dismissImagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma messaging

- (IBAction)sendButtonAction:(id)sender {
    
    [self saveMessageToFirebase];
    [self showUploadingState];
}

-(void)saveMessageToFirebase {
    
    FIRUser * currentUser = [FIRAuth auth].currentUser;
    
    NSLog(@"CURRENT USER %@", currentUser);
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    NSString * key = [[ref child:@"messages"] childByAutoId].key;
    
    [self uploadImageToFirebase:key];
    
    NSMutableDictionary * message = [[NSMutableDictionary alloc]init];
    
    [message setValue:currentUser.uid forKey:@"sender"];
    [message setValue:currentUser.displayName forKey:@"senderUsername"];
    [message setValue:self.messageTextField.text forKey:@"messageText"];
    
    NSLog(@"RECIPIENT %@", self.recipientInfo);
    
    NSString *messagePathString = [NSString stringWithFormat:@"/messages/%@/", self.recipientInfo[@"uid"]];
    
    NSDictionary *childUpdates = @{[messagePathString stringByAppendingString:key] : message};
    
    [ref updateChildValues:childUpdates];
    

    
}



-(void)uploadImageToFirebase:(NSString *)key {
    
    FIRStorageReference * storageRef = [[FIRStorage storage] reference];
    
    NSString * imagesPath = [NSString stringWithFormat:@"/images/%@", key];
    
    FIRStorageReference * imagesRef = [storageRef child:imagesPath];
    
    NSData * imageData = UIImageJPEGRepresentation(self.messageImageView.image, 0.5);
    
    FIRStorageMetadata * metaData = [FIRStorageMetadata new];
    metaData.contentType = @"image/jpeg";
    
    [imagesRef putData:imageData metadata:metaData completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil)
        {
            NSLog(@"error %@", error);
            [self finishUploadingState];
            return;
        }
        
        NSLog(@"success! metadata %@", metaData);
        
        [self popToHomeViewController];
        
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

-(void)showUploadingState {
    [self.sendButton setTitle:@"" forState:UIControlStateNormal];
    [self.activityIndicator startAnimating];
    self.sendButton.userInteractionEnabled = NO;
    self.messageImageView.userInteractionEnabled = NO;
    self.messageTextField.userInteractionEnabled = NO;
}

-(void)finishUploadingState {
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.activityIndicator stopAnimating];
    self.sendButton.userInteractionEnabled = YES;
    self.messageImageView.userInteractionEnabled = YES;
    self.messageTextField.userInteractionEnabled = YES;
}





@end

