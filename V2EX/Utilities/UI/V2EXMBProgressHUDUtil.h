//
//  V2EXMBProgressHUDUtil.h
//  V2EX
//
//  Created by WildCat on 2/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface V2EXMBProgressHUDUtil : NSObject

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg;
@end
