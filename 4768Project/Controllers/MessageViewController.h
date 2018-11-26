//
//  MessageViewController.h
//  4768Project
//
//  Created by Liam  on 2018-11-22.
//  Copyright © 2018 Liam Reardon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController {
    
    int currSeconds;
}

@property (strong, nonatomic) NSDictionary *messageInfo;
@property (strong, nonatomic) NSString * messageKey;


@end

NS_ASSUME_NONNULL_END
