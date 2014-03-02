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
    V2EXNormalModel *_model;
}
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *userMetaLabel;
@property (strong, nonatomic) IBOutlet DTAttributedLabel *userSocialInformationLabel;

- (IBAction)showMenu:(id)sender;

@end
