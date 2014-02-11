//
//  V2EXAppSize.h
//  V2EX
//
//  Created by WildCat on 2/9/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V2EXAppSize : NSObject

+ (CGFloat)getHeightWithController:(UIViewController *)controller;
+ (CGFloat)getWidthWithController:(UIViewController *)controller;
+ (CGFloat)getStatusBarHeight;
+ (CGFloat)getNavBarHeight4Controller:(UIViewController *)controller;


@end
