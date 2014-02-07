//
//  V2EXMBProgressHUDUtil.m
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXMBProgressHUDUtil.h"

@implementation V2EXMBProgressHUDUtil

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    hud.userInteractionEnabled = NO;
    return hud;
}

+ (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    
    static MBProgressHUD* hud = nil;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 0.8f;
    [hud hide:YES afterDelay:3.5f];
    return hud;
}

@end
