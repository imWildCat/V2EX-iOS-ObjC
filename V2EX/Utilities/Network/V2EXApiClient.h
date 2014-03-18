//
//  V2EXApiClient.h
//  V2EX
//
//  Created by WildCat on 1/31/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#define DEFAULT_USET_AGENT @"5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16"

@interface V2EXApiClient : NSObject
{
    //Using AFHTTPSessionManager temporarily to support cookies
    AFHTTPSessionManager *_manager;

    BOOL _isHTTPS;
    
    BOOL _isLoading;
}
+ (V2EXApiClient *)sharedClient;

- (void) managerRequestData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)params success:(void (^)(id dataObject))success failure:(void (^)(NSError *error))failure;

@end
