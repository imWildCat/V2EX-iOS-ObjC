//
//  V2EXUserLoginViewController.h
//  V2EX
//
//  Created by WildCat on 3/1/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXApiClient.h"

@interface V2EXUserLoginViewController : UIViewController
{
    //AFNetWorking
    AFHTTPSessionManager *_manager;
    AFHTTPRequestSerializer *_requestSerializer;
    AFHTTPResponseSerializer *_responseSerializer;
}

@property BOOL isLoadFromSeflController;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)doLogin:(id)sender;
- (IBAction)resetPassword:(id)sender;

+ (void)logout;
@end
