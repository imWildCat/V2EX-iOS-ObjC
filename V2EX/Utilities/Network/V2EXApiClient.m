//
//  V2EXApiClient.m
//  V2EX
//
//  Created by WildCat on 1/31/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXApiClient.h"
#import "V2EXHttpRequestSerializer.h"

#define HTTP_ROOT_URL @"http://www.v2ex.com/"
#define HTTPS_ROOT_URL @"https://www.v2ex.com/"
#define JSONAPI_URI @"api/"
//TODO: Adding more support for user agent.


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
            V2EXHttpRequestSerializer *requestSerializer = [V2EXHttpRequestSerializer serializer];
            [requestSerializer setValue:DEFAULT_USET_AGENT forHTTPHeaderField:@"User-Agent"];
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
            
            [_manager setRequestSerializer:requestSerializer];
            [_manager setResponseSerializer:responseSerializer];
    } else {
            V2EXHttpRequestSerializer *requestSerializer = [V2EXHttpRequestSerializer serializer];
            [requestSerializer setValue:DEFAULT_USET_AGENT forHTTPHeaderField:@"User-Agent"];
            AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
            [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
            
            [_manager setRequestSerializer:requestSerializer];
            [_manager setResponseSerializer:responseSerializer];
    }
}

/**
 *  Returns V2EX base http or https url according to (BOOL)_isHTTPS.
 *
 *  @return HTTP_ROOT_URL or HTTP_ROOT_URL.
 */
- (NSString *) _getBaseUrl:(BOOL)isJsonApi{
    NSString *rootUrl;
    if(_isHTTPS){
        rootUrl = HTTPS_ROOT_URL;
    } else {
        rootUrl =  HTTP_ROOT_URL;
    }
    if (isJsonApi) {
        return [rootUrl stringByAppendingString:JSONAPI_URI];
    } else {
        return rootUrl;
    }
}

- (void)managerRequestData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)params success:(void (^)(id dataObject))success failure:(void (^)(NSError *error))failure
{
    [self _setSerializer:isJsonApi];
    NSString *url = [[self _getBaseUrl:isJsonApi] stringByAppendingString:uri];
    if (!_isLoading) {
        _isLoading = YES;
        if(isGetMethod){
            [_manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                _isLoading = NO;
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                _isLoading = NO;
                failure(error);
            }];
        } else {
            [_manager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                _isLoading = NO;
                success(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                _isLoading = NO;
                failure(error);
            }];
        }
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"V2EX" code:444 userInfo:nil];
        failure(error);
    }

}


- (void) _managerGetJson:(NSString *)uri parameters:(NSDictionary *)params success:(void (^)(NSDictionary *jsonData))success failure:(void (^)(NSString *errorMessage))failure
{
    [self managerRequestData:uri isGetMethod:YES isJsonApi:YES parameters:nil success:^(id data) {
        success(data);
    } failure:^(NSError *error) {
        failure([error description]);
    }];
}




@end
