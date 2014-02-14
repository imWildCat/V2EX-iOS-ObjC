//
//  V2EXStringUtil.h
//  V2EX
//
//  Created by WildCat on 2/14/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V2EXStringUtil : NSObject

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
+ (NSString *)stringByStrippingHTML:(NSString *)inputString;
+ (NSString *)filterHTML:(NSString *)html;

@end
