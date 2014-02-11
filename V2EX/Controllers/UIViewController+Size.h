//
//  UIViewController+Size.h
//  V2EX
//
//  Created by WildCat on 2/9/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Size)

- (CGFloat)getHeight;
- (CGFloat)getWidth;
- (CGFloat)getStatusBarHeight;
- (CGFloat)getNavBarHeight;

@end
