//
//  V2EXSelfViewController.h
//  V2EX
//
//  Created by WildCat on 3/1/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "V2EXNormalModel.h"
#import <DTAttributedLabel.h>

@interface V2EXSelfViewController : UIViewController <V2EXRequestDataDelegate>
{
    NSUInteger _loadingStatus; // 0 - No loading ; 1 - Loading my topics ; 2 - Loading my replies ; 3 - Loading notification
    V2EXNormalModel *_model;
    
    NSString *_currentUsername;
}
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *userMetaLabel;
//@property (strong, nonatomic) IBOutlet DTAttributedLabel *userSocialInformationLabel;
@property (strong, nonatomic) IBOutlet UIButton *myTopicsButton;
@property (strong, nonatomic) IBOutlet UIButton *myRepliesButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationCenterButton;

- (IBAction)showMenu:(id)sender;
- (IBAction)myTopicsButtonClick:(id)sender;
- (IBAction)myRepliesButtonClick:(id)sender;
- (IBAction)notificationCenterButtonClick:(id)sender;

@end
