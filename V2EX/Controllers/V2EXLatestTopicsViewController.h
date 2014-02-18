//
//  V2EXLatestTopicsViewController.h
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import "UIViewController+MBProgressHUD.h"
#import "V2EXTableViewController.h"
#import "V2EXNormalModel.h"

@interface V2EXLatestTopicsViewController : V2EXTableViewController

+ (V2EXLatestTopicsViewController *)sharedController;
- (IBAction)showMenu:(id)sender;

@end
