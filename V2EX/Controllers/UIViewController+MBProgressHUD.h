//
//  UIViewController+MBProgressHUD.h
//  V2EX
//
//  Created by WildCat on 2/5/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MBProgressHUD)

- (void) showProgressView;
- (void) hideProgressView;
- (void) showMessage:(NSString *)message;

@end
