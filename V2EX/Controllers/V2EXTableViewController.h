//
//  V2EXTableViewController.h
//  V2EX
//
//  Created by WildCat on 2/7/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXRequestDataDelegate.h"
#import "UIViewController+MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface V2EXTableViewController : UITableViewController <V2EXRequestDataDelegate>

@property (nonatomic,strong) id receivedData;

@end
