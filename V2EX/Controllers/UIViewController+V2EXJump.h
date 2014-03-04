//
//  UIViewController+V2EXJump.h
//  V2EX
//
//  Created by WildCat on 3/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2EXTableViewController.h"

@interface V2EXTableViewController (V2EXJump)

- (void)pushToUserLoginController;
- (void)pushToUserLoginController:(BOOL)isLoadFromSeflController;

@end
