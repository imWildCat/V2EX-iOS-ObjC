//
//  UIViewController+MBProgressHUD.m
//  V2EX
//
//  Created by WildCat on 2/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"
#import "V2EXMBProgressHUDUtil.h"

@implementation UIViewController (MBProgressHUD)

-(void)showProgressView {
    [V2EXMBProgressHUDUtil showGlobalProgressHUDWithTitle:nil];
}

-(void)hideProgressView {
    [V2EXMBProgressHUDUtil dismissGlobalHUD];
}

-(void)showMessage:(NSString *)message {
    [V2EXMBProgressHUDUtil showMessage:message];
}
@end
