//
//  V2EXNormalModel.m
//  V2EX
//
//  Created by WildCat on 2/8/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXNormalModel.h"
#import "JSONAPIURI.h"

@implementation V2EXNormalModel

// Base Data
- (void)getJSONData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:YES parameters:parameter];
}

- (void)getHTMLData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:NO parameters:parameter];
}

// HTML Data
- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:NO isJsonApi:NO parameters:parameter];
}

- (void)getIndex {
    [self getHTMLData:@"" parameters:nil];
}

- (void)getTopicsList:(NSString *)URI {
    [self getHTMLData:[@"go/" stringByAppendingString:URI] parameters:nil];
}

- (void)getTopicWithLinkURI:(NSString *)URI {
    [self getHTMLData:[URI stringByReplacingOccurrencesOfString:@"/t/" withString:@"t/"] parameters:nil];
}

- (void)getTopicWithID:(NSString *)id {
    [self getHTMLData:[@"t/" stringByAppendingString:id] parameters:nil];
}


// JSON API
- (void)getLatestTopics {
    [self getJSONData:TOPICS_LATEST parameters:nil];
}

- (void)getAllNodes {
    [self getJSONData:NODES_ALL parameters:nil];
}

@end
