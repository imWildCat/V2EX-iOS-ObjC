//
//  V2EXApiClient.m
//  V2EX
//
//  Created by WildCat on 1/31/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXApiClient.h"

#define HTTP_ROOT_URL @"http://www.v2ex.com/api/"
#define HTTPS_ROOT_URL @"https://www.v2ex.com/api/"
#define SITE_STATS @"site/stats.json"
#define SITE_INFO @"site/info.json"
#define NODES_ALL @"nodes/all.json"
#define NODES_SHOW @"nodes/show.json"
#define TOPICS_LATEST @"topics/latest.json"
//TODO: Adding more support for user agent.
#define DEFAULT_USET_AGENT @"5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16"

@implementation V2EXApiClient

- (id)init
{
    self = [super init];
    _manager = [AFHTTPSessionManager manager];
    _isHTTPS = NO;

    return self;
}

+ (V2EXApiClient *)sharedClient
{
    static V2EXApiClient *_sharedClientInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedClientInstance = [[self alloc] init];
        
    });
    
    return _sharedClientInstance;
}

/**
 *  Sets _manager.requestSerializer and _manager setResponseSerializer according to (BOOL)isJsonApi.
 *
 *  @param isJsonApi If using V2EX JSON API.
 */
- (void) _setSerializer:(BOOL)isJsonApi{

    if(isJsonApi){
        if(![_manager.requestSerializer isMemberOfClass:[AFJSONRequestSerializer class]]){
            AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
            [requestSerializer setValue:DEFAULT_USET_AGENT forHTTPHeaderField:@"User-Agent"];
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
            
            [_manager setRequestSerializer:requestSerializer];
            [_manager setResponseSerializer:responseSerializer];
        }
    } else {
        if(![_manager.requestSerializer isMemberOfClass:[AFHTTPRequestSerializer class]]){
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            [requestSerializer setValue:DEFAULT_USET_AGENT forHTTPHeaderField:@"User-Agent"];
            AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
            [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
            
            [_manager setRequestSerializer:requestSerializer];
            [_manager setResponseSerializer:responseSerializer];
        }
    }
}

/**
 *  Returns V2EX base http or https url according to (BOOL)_isHTTPS.
 *
 *  @return HTTP_ROOT_URL or HTTP_ROOT_URL.
 */
- (NSString *) _getBaseUrl{
    if(_isHTTPS){
        return HTTPS_ROOT_URL;
    } else {
        return HTTP_ROOT_URL;
    }
}

- (void) _managerGetJson:(NSString *)uri parameters:(NSDictionary *)params success:(void (^)(NSDictionary *jsonData))success failure:(void (^)(NSString *errorMessage))failure
{
    [self _setSerializer:YES];
    NSString *url = [[self _getBaseUrl] stringByAppendingString:uri];
    [_manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure([error description]);
    }];
}

- (void)getLatestTopics:(void(^)(id topicsData))success failure:(void (^)(NSString *))failure
{
    [self _managerGetJson:TOPICS_LATEST parameters:nil success:^(NSDictionary *jsonData) {
        success(jsonData);
    } failure:^(NSString *errorMessage) {
        failure(errorMessage);
    }];
}



@end
