//
//  V2EXUserUtil.h
//  V2EX
//
//  Created by WildCat on 3/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TFHpple.h>

@interface V2EXUserUtil : NSCache

+ (BOOL)isLogin:(TFHpple *)doc;

@end
