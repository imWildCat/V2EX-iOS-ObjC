//
//  V2EXAbstractModel.m
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"
#import "V2EXMBProgressHUDUtil.h"

@implementation V2EXAbstractModel

- (id)init {
    [NSException raise:@"V2EXAbstractModel Exception" format:@"can't use init method"];
    return self;
}

- (id)initWithDelegate:(id <V2EXRequestDataDelegate>)delegate {
    self = [super init];
    if(self){
        _delegate = delegate;
        self.apiClient = [V2EXApiClient sharedClient];
    }
    return self;
}

- (void)loadData:(NSString *)uri isGetMethod:(BOOL)isGetMethod isJsonApi:(BOOL)isJsonApi parameters:(NSDictionary *)parameters {
        [self.apiClient managerRequestData:uri isGetMethod:isGetMethod isJsonApi:isJsonApi parameters:parameters success:^(id dataObject) {
            [self loadDataSuccess:[self parseData:dataObject]];
        } failure:^(NSError *error) {
            [self loadDataFailure:error];
        }];
    
}

- (NSDictionary *) parseData:(id)dataObject {
    //Optional to be overwritten.
    return dataObject;
}

- (void)loadDataSuccess:(id)dataObject {
    [V2EXMBProgressHUDUtil dismissGlobalHUD];
    [_delegate requestDataSuccess:dataObject];
}

- (void)loadDataFailure:(NSError *)error {
    NSString *errorMessage;
    switch ([error code]) {
        case 444:
            errorMessage = @"抱歉，请等待上一次请求完成";
            break;
        case -1009:
            errorMessage = @"加载失败，似乎没有连接到网络";
            break;
        default:
            errorMessage = @"网络错误，加载失败";
            break;
    }
    [V2EXMBProgressHUDUtil dismissGlobalHUD];
    
    [V2EXMBProgressHUDUtil showMessage:errorMessage];
    if ([_delegate respondsToSelector:@selector(requestDataFailure:)]) {
        [_delegate requestDataFailure:errorMessage];
    }
    
    NSLog(@"[ERROR] Network: %@", [error description]);
}


// Base Data
- (void)getJSONData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:YES parameters:parameter];
}

// HTML Data
- (void)getHTMLData:(NSString *)uri parameters:(NSDictionary *)parameter {
    [self loadData:uri isGetMethod:YES isJsonApi:NO parameters:parameter];
}

- (void)postData:(NSString *)uri parameters:(NSDictionary *)parameter {
//    NSMutableString *uriWithParam = [uri mutableCopy];
//    if ([parameter count] > 0) {
//        [uriWithParam appendString:@"?"];
//        BOOL isFirst = YES;
//
//        for (NSString *key in [parameter allKeys] ) {
//            NSString *value = [parameter objectForKey:key];
//            
//            if (!isFirst) {
//                [uriWithParam appendString:@"&"];
//            }
//            
//            [uriWithParam appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
//        }
//    }

//    [self loadData:uriWithParam isGetMethod:NO isJsonApi:NO parameters:nil];
    [self loadData:uri isGetMethod:NO isJsonApi:NO parameters:parameter];
}

@end
