//
//  V2EXAppSize.m
//  V2EX
//
//  Created by WildCat on 2/9/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAppSize.h"

@implementation V2EXAppSize

+ (CGFloat)_getSystemHeight {
    //    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    CGSize size = rect.size;
    return size.width;
}

+ (CGFloat)_getSystemWidth {
    //    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    CGSize size = rect.size;
    return size.height;
}

+ (CGFloat)getHeightWithController:(UIViewController *)controller {
    if (UIDeviceOrientationIsPortrait(controller.interfaceOrientation)) {
        return [self _getSystemWidth];
    } else {
        return [self _getSystemHeight];
    }
}

+ (CGFloat)getWidthWithController:(UIViewController *)controller {
    if (UIDeviceOrientationIsPortrait(controller.interfaceOrientation)) {
        return [self _getSystemHeight]; 
    } else {
        return [self _getSystemWidth];
    }
}

+ (CGFloat)getStatusBarHeight {
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.height;
}

+ (CGFloat)getNavBarHeight4Controller:(UIViewController *)controller {
    return controller.navigationController.navigationBar.frame.size.height;
}

@end
