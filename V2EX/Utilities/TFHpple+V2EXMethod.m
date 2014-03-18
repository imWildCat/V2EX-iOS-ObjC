//
//  TFHpple+V2EXMethod.m
//  V2EX
//
//  Created by WildCat on 3/6/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "TFHpple+V2EXMethod.h"

@implementation TFHpple (V2EXMethod)

- (TFHppleElement *)searchFirstElementWithXPathQuery:(NSString *)query {
    NSArray *retArray = [self searchWithXPathQuery:query];
    if ([retArray count] > 0) {
        return [retArray objectAtIndex:0];
    }
    return nil;
}

- (BOOL)checkLogin {
    TFHppleElement *userLinkElement = [self searchFirstElementWithXPathQuery:@"//div[@id='Top']//table//td[@width='auto']//a[@class='top']"];
    if (userLinkElement) {
        NSString *username =[[userLinkElement objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"/member/" withString:@""];
        if ([username length] > 0) {
            return YES;
        }
    }
    return NO;
}

@end
