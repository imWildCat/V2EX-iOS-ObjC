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
#import "V2EXTopicsListCell.h"
#import "V2EXRequestDataDelegate.h"
#import "V2EXLastestTopicsModel.h"

@interface V2EXLatestTopicsViewController : UITableViewController <V2EXRequestDataDelegate>
{
    V2EXLastestTopicsModel *_latestTopicsModel;
}

- (IBAction)showMenu:(id)sender;

@property (nonatomic,strong) id topicsData;
@end
