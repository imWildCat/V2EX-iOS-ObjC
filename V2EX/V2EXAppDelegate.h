//
//  V2EXAppDelegate.h
//  V2EX
//
//  Created by WildCat on 1/30/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "V2EXLatestTopicsViewController.h"
#import "V2EXNodesListViewController.h"

@interface V2EXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) V2EXNodesListViewController *sharedNodesListViewController;
@property (retain, nonatomic) V2EXLatestTopicsViewController *sharedLatestTopicsViewController;


@end
