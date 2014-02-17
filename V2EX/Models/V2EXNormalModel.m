//
//  V2EXNormalModel.m
//  V2EX
//
//  Created by WildCat on 2/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNormalModel.h"
#import <TFHpple.h>

@implementation V2EXNormalModel

- (void)getHTMLData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:NO parameters:parameter];
}

- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:NO isJsonApi:NO parameters:parameter];
}

- (void)getIndex {
    [self getHTMLData:@"" parameters:nil];
}

- (void)getTopicsList:(NSString *)URI {
    [self getHTMLData:[@"go/" stringByAppendingString:URI] parameters:nil];
}

@end
