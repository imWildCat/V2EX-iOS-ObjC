//
//  V2EXApiClient.h
//  V2EX
//
//  Created by WildCat on 1/31/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface V2EXApiClient : NSObject
{
    //Using AFHTTPSessionManager temporarily to support cookies
    AFHTTPSessionManager *_manager;

    BOOL _isHTTPS;
}
+ (V2EXApiClient *)sharedClient;

- (void) managerRequestData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)params success:(void (^)(id dataObject))success failure:(void (^)(NSError *error))failure;

@end
