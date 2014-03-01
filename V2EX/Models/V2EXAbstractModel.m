//
//  V2EXAbstractModel.m
//  V2EX
//
//  Created by WildCat on 2/3/14.
//  Copyright (c) 2014 WildCat. All rights reserved.
//

#import "V2EXAbstractModel.h"

@implementation V2EXAbstractModel

- (id)initWithDelegate:(id <V2EXRequestDataDelegate>)delegate {
    self = [self init];
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
    
    [_delegate requestDataFailure:errorMessage];
    NSLog(@"%i", [error code]);

    NSLog(@"%@", [error description]);
}

@end
