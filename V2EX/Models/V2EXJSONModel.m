//
//  V2EXJSONModel.m
//  V2EX
//
//  Created by WildCat on 2/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXJSONModel.h"
#import "JSONAPIURI.h"

@implementation V2EXJSONModel

- (void)getJSONData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:YES parameters:parameter];
}

- (void)getLatestTopics {
    [self getJSONData:TOPICS_LATEST parameters:nil];
}

@end
