//
//  UIViewController+Size.m
//  V2EX
//
//  Created by WildCat on 2/9/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "UIViewController+Size.h"
#import "V2EXAppSize.h"

@implementation UIViewController (Size)

- (CGFloat)getHeight {
    return [V2EXAppSize getHeightWithController:self];
}

- (CGFloat)getWidth {
    return [V2EXAppSize getWidthWithController:self];
}

- (CGFloat)getStatusBarHeight {
    return [V2EXAppSize getStatusBarHeight];
}

- (CGFloat)getNavBarHeight {
    return [V2EXAppSize getNavBarHeight4Controller:self];
}

@end
