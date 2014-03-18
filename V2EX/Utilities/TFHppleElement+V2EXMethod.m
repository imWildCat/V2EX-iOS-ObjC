//
//  TFHppleElement+V2EXMethod.m
//  V2EX
//
//  Created by WildCat on 3/18/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "TFHppleElement+V2EXMethod.h"

@implementation TFHppleElement (V2EXMethod)

// TODO: Is there any better implementation
- (TFHppleElement *)searchFirstElementWithXPathQuery:(NSString *)query {
    NSArray *retArray = [self searchWithXPathQuery:query];
    if ([retArray count] > 0) {
        return [retArray objectAtIndex:0];
    }
    return nil;
}

@end
