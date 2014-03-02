//
//  V2EXUserUtil.m
//  V2EX
//
//  Created by WildCat on 3/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXUserUtil.h"

@implementation V2EXUserUtil

+ (BOOL)isLogin:(TFHpple *)doc {
    NSArray *usernameArray = [doc searchWithXPathQuery:@"//div[@id='Top']//table//td[@width='auto']//a[@class='top']"];
    if ([usernameArray count] > 0) {
        NSString *username =[[[usernameArray objectAtIndex:0] objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"/member/" withString:@""];
        if ([username length] > 0) {
            return YES;
        }
    }
    return NO;
}

@end
