//
//  V2EXHttpRequestSerializer.m
//  V2EX
//
//  Created by WildCat on 2/7/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXHttpRequestSerializer.h"

@implementation V2EXHttpRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    [request setTimeoutInterval:5];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return request;
}

@end
