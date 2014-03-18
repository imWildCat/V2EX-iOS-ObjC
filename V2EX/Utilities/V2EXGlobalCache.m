//
//  V2EXGlobalCache.m
//  V2EX
//
//  Created by WildCat on 3/2/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXGlobalCache.h"
#import "V2EXAppDelegate.h"

@implementation V2EXGlobalCache

+ (V2EXGlobalCache *)cache {
    static V2EXGlobalCache *_cache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _cache = [[V2EXGlobalCache alloc] init];
    });
    
    return _cache;
}

@end
