//
//  UIViewController+V2EXJump.m
//  V2EX
//
//  Created by WildCat on 3/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "UIViewController+V2EXJump.h"
#import "V2EXUserLoginViewController.h"

@implementation UIViewController (V2EXJump)

- (void)pushToUserLoginController {
    [self pushToUserLoginController:NO];
}

- (void)pushToUserLoginController:(BOOL)isLoadFromSeflController {
    V2EXUserLoginViewController *userLoginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"userLoginController"];
    userLoginController.isLoadFromSeflController = isLoadFromSeflController;
    [self.navigationController pushViewController:userLoginController animated:YES];
}

@end
