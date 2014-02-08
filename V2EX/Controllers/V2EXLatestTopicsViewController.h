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
#import "V2EXJSONModel.h"
#import "V2EXTableViewController.h"

@interface V2EXLatestTopicsViewController : V2EXTableViewController
{
    V2EXJSONModel *_jsonModel;
}

- (IBAction)showMenu:(id)sender;

@end
